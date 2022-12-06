#
# Transfer Identity Provider IAM Role
#
resource "aws_iam_role" "this_transfer" {
  count              = var.create_transfer_iam_role ? 1 : 0
  assume_role_policy = data.aws_iam_policy_document.transfer_trust_policy.json
  name               = var.transfer_iam_role_name
  tags               = merge({
    Name = var.transfer_iam_role_name, Role = "${var.transfer_iam_role_name} iam role"
  }, var.tags)
}

resource "aws_iam_role_policy" "transfer_inline_policy" {
  count  = var.create_transfer_iam_role ? 1 : 0
  policy = data.aws_iam_policy_document.transfer_inline_policy[0].json
  role   = aws_iam_role.this_transfer[0].id
  name   = "TransferAllowAPIInteractions"
}
#
# Transfer Identity Provider Lambda IAM Role
#
resource "aws_iam_role" "this_lambda" {
  count              = var.create_lambda_iam_role ? 1 : 0
  assume_role_policy = data.aws_iam_policy_document.lambda_trust_policy.json
  name               = var.lambda_iam_role_name
  tags               = merge({
    Name = var.lambda_iam_role_name,
    Role = "${var.lambda_iam_role_name} iam role"
  }, var.tags )
}

resource "aws_iam_role_policy" "inline_policy" {
  count  = var.create_lambda_iam_role ? 1 : 0
  policy = data.aws_iam_policy_document.lambda_inline_policy[0].json
  role   = aws_iam_role.this_lambda[0].id
  name   = "LambdaSecretsPolicy"
}

resource "aws_iam_role_policy_attachment" "policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.this_lambda[0].name
}

#
# Lambda Deployment
#
resource "aws_lambda_function" "this_lambda" {
  function_name    = var.identity_provider_lookup_lambda_name
  handler          = "lambda.lambda_handler"
  role             = coalesce(concat(aws_iam_role.this_lambda.*.arn, [])[0], var.lambda_role_arn)
  runtime          = "python3.9"
  description      = "A function to lookup and return user data from AWS Secrets Manager."
  tags             = var.tags
  filename         = "${path.module}/lib/lambda.zip"
  source_code_hash = filebase64sha256("${path.module}/lib/lambda.zip")

  environment {
    variables = {
      SECRET_BASE_PATH     = var.secret_base_path
      SecretsManagerRegion = data.aws_region.current.name
    }
  }
}

resource "aws_lambda_permission" "allow_apigw_invoke" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.this_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.this.execution_arn}/*/GET/servers/*/users/*/config"
}

#
# API Gateway
#
resource "aws_api_gateway_rest_api" "this" {
  name        = var.api_gateway_rest_api_name
  description = "This API provides authentication for Transfer Family servers"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
  tags = merge({
    Name = var.api_gateway_rest_api_name,
    Role = "${var.api_gateway_rest_api_name} iam role"
  }, var.tags)
}

resource "aws_api_gateway_resource" "servers" {
  parent_id   = aws_api_gateway_rest_api.this.root_resource_id
  rest_api_id = aws_api_gateway_rest_api.this.id
  path_part   = "servers"
}

resource "aws_api_gateway_resource" "server_id" {
  parent_id   = aws_api_gateway_resource.servers.id
  rest_api_id = aws_api_gateway_rest_api.this.id
  path_part   = "{serverId}"
}

resource "aws_api_gateway_resource" "users" {
  parent_id   = aws_api_gateway_resource.server_id.id
  rest_api_id = aws_api_gateway_rest_api.this.id
  path_part   = "users"
}

resource "aws_api_gateway_resource" "user_name" {
  parent_id   = aws_api_gateway_resource.users.id
  rest_api_id = aws_api_gateway_rest_api.this.id
  path_part   = "{username}"
}

resource "aws_api_gateway_resource" "user_config" {
  parent_id   = aws_api_gateway_resource.user_name.id
  rest_api_id = aws_api_gateway_rest_api.this.id
  path_part   = "config"
}

resource "aws_api_gateway_model" "get_user_response_model" {
  content_type = "application/json"
  name         = "UserConfigResponseModel"
  description  = "API response for GetUserConfig"
  rest_api_id  = aws_api_gateway_rest_api.this.id
  schema       = jsonencode({
    "$schema"  = "http://json-schema.org/draft-04/schema#"
    title      = "UserUserConfig"
    type       = "object"
    properties = {
      HomeDirectory = {
        type = "string"
      }
      Role = {
        type = "string"
      }
      Policy = {
        type : "string"
      }
      PublicKeys = {
        type  = "array"
        items = {
          type = "string"
        }
      }
    }
  })
}

resource "aws_api_gateway_method" "get_user_config" {
  authorization      = "AWS_IAM"
  http_method        = "GET"
  resource_id        = aws_api_gateway_resource.user_config.id
  rest_api_id        = aws_api_gateway_rest_api.this.id
  //  depends_on         = [aws_api_gateway_model.get_user_response_model]
  request_parameters = {
    "method.request.header.Password"      = false
    "method.request.querystring.protocol" = false
    "method.request.querystring.sourceIp" = false
  }
}
resource "aws_api_gateway_method_response" "get_user_config_response" {
  http_method     = aws_api_gateway_method.get_user_config.http_method
  resource_id     = aws_api_gateway_resource.user_config.id
  rest_api_id     = aws_api_gateway_rest_api.this.id
  status_code     = "200"
  response_models = {
    "application/json" = "UserConfigResponseModel"
  }
}

resource "aws_api_gateway_integration" "get_user_config_post_integration" {
  http_method             = aws_api_gateway_method.get_user_config.http_method
  integration_http_method = "POST"
  resource_id             = aws_api_gateway_resource.user_config.id
  rest_api_id             = aws_api_gateway_rest_api.this.id
  type                    = "AWS"
  # arn:aws:apigateway:eu-west-1:lambda:path/2015-03-31/functions/<lamba invoke arn>
  uri                     = aws_lambda_function.this_lambda.invoke_arn
  request_templates       = {
    "application/json" = "{ \"username\": \"$input.params('username')\", \"password\": \"$util.escapeJavaScript($input.params('Password')).replaceAll(\"\\\\'\",\"'\")\", \"serverId\": \"$input.params('serverId')\", \"protocol\": \"$input.params('protocol')\",\"sourceIp\": \"$input.params('sourceIp')\" }"
  }
}

resource "aws_api_gateway_integration_response" "get_user_config_post_integration_response" {
  http_method = aws_api_gateway_integration.get_user_config_post_integration.http_method
  resource_id = aws_api_gateway_resource.user_config.id
  rest_api_id = aws_api_gateway_rest_api.this.id
  status_code = "200"
}

resource "aws_api_gateway_deployment" "this" {
  rest_api_id = aws_api_gateway_rest_api.this.id
}

resource "aws_api_gateway_stage" "prod" {
  deployment_id = aws_api_gateway_deployment.this.id
  rest_api_id   = aws_api_gateway_rest_api.this.id
  stage_name    = var.api_gateway_stage_name
  tags          = merge({
    Name = "${aws_api_gateway_rest_api.this.name} stage ${var.api_gateway_stage_name}",
    Role = "${aws_api_gateway_rest_api.this.name} stage ${var.api_gateway_stage_name}"
  }, var.tags
  )
}

resource "aws_api_gateway_method_settings" "settings" {
  # All resources / All methods within this stage
  method_path = "*/*"
  rest_api_id = aws_api_gateway_rest_api.this.id
  stage_name  = aws_api_gateway_stage.prod.stage_name
  settings {
    data_trace_enabled = false
    logging_level      = "INFO"
  }
}



