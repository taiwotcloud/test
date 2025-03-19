variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "user_pool_name" {
  description = "Existing Cognito User Pool Name"
  type        = string
  default     = "ExistingDataZoneUserPool"
}

variable "user_pool_id" {
  description = "The ID of the existing Cognito User Pool"
  type        = string
}

variable "user_pool_client_name" {
  description = "Cognito User Pool Client Name"
  type        = string
  default     = "DataZoneAppClient"
}

variable "saml_provider_name" {
  description = "SAML Identity Provider Name"
  type        = string
  default     = "eAuth-ICAM-SAML"
}

variable "saml_metadata_url" {
  description = "Metadata URL for the SAML Identity Provider"
  type        = string
  default     = "https://eauth-icam-metadata-url"
}

variable "callback_urls" {
  description = "Callback URLs for Cognito Authentication"
  type        = list(string)
  default     = ["https://dzd_581xa3qdroeazr.datazone.us-east-1.on.aws/callback"]
}

variable "logout_urls" {
  description = "Logout URLs for Cognito Authentication"
  type        = list(string)
  default     = ["https://dzd_581xa3qdroeazr.datazone.us-east-1.on.aws/logout"]
}

variable "iam_role_name" {
  description = "IAM Role for Cognito-Authenticated Users"
  type        = string
  default     = "CognitoAuthenticatedRole"
}

variable "policy_name" {
  description = "IAM Policy for Cognito-Authenticated Users"
  type        = string
  default     = "DataZoneAccessPolicy"
}
