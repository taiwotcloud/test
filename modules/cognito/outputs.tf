output "saml_provider_id" {
  description = "ID of the SAML Identity Provider"
  value       = aws_cognito_identity_provider.saml_provider.id  # ✅ Correct attribute
}

output "user_pool_client_id" {
  description = "Cognito User Pool Client ID"
  value       = aws_cognito_user_pool_client.cognito_client.id
}

output "iam_role_arn" {
  description = "IAM Role ARN for Cognito-Authenticated Users"
  value       = aws_iam_role.cognito_authenticated_role.arn
}
