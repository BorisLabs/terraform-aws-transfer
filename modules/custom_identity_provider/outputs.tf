# URL to pass to AWS Transfer CreateServer call as part of optional IdentityProviderDetails
output "transfer_identity_provider_url" {
  value = aws_api_gateway_stage.prod.invoke_url
}