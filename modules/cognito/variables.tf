variable "user_pool_name" {
  description = "Existing Cognito User Pool Name"
  type        = string
}

variable "user_pool_client_name" {
  description = "Cognito User Pool Client Name"
  type        = string
}

variable "user_pool_id" {
  description = "The ID of the existing Cognito User Pool"
  type        = string
}


variable "saml_provider_name" {
  description = "SAML Identity Provider Name"
  type        = string
}

variable "saml_metadata_url" {
  description = "Metadata URL for the SAML Identity Provider"
  type        = string
}

variable "callback_urls" {
  description = "Callback URLs for Cognito Authentication"
  type        = list(string)
}

variable "logout_urls" {
  description = "Logout URLs for Cognito Authentication"
  type        = list(string)
}

variable "iam_role_name" {
  description = "IAM Role for Cognito-Authenticated Users"
  type        = string
}

variable "policy_name" {
  description = "IAM Policy for Cognito-Authenticated Users"
  type        = string
}
