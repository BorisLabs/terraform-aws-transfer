# URL to pass to AWS Transfer CreateServer call as part of optional IdentityProviderDetails
output "transfer_identity_provider_url" {
  value = aws_api_gateway_stage.prod.invoke_url
}

# Role ARN to pass to AWS Transfer CreateServer call as part of optional IdentityProviderDetails
output "transfer_identity_provider_role_arn" {
  value = aws_iam_role.this_transfer[0].arn
}