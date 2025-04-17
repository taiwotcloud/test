variable "aws_cognito_user_pool_name" {
  type        = string
  description = "Name for Cognito user pool"
  default     = null
}



variable "aws_cognito_identity_provider_name" {
  description = "User pool's identity provider name (string)"
  type        = string
  default     = null
}

variable "aws_cognito_user_pool_domain" {
  description = "Domain for user pool (i.e. cognito-eauth)"
  type        = string
  default     = null
}

variable "aws_cognito_identity_provider_type" {
  description = "User pool's identity provider type (string)"
  type        = string
  default     = "OIDC"
}

variable "authorize_scopes" {
  description = "User pool's authorized scopes (string)"
  type        = string
  default     = "openid email profile usda_credential_data usda_position_data"
}


variable "alias_attributes" {
  description = "User pool's alias attributes (string)"
  type        = list(string)
  default     = ["preferred_username"]
}

variable "aws_cognito_identity_saml_provider_type" {
  description = "User pool's identity provider type (string)"
  type        = string
  default     = "SAML"
}

variable "user_pool_client_name" {
  description = "Cognito User Pool Client Name"
  type        = string
}

variable "iam_role_name" {
  description = "IAM Role for Cognito-Authenticated Users"
  type        = string
}

variable "policy_name" {
  description = "IAM Policy for Cognito-Authenticated Users"
  type        = string
}

variable "user_pool_id" {
  description = "The ID of the existing Cognito User Pool"
  type        = string
}

variable "user_pool_client_SAML" {
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
  description = "Callback URLs for the Cognito user pool client"
  type        = list(string)
}

variable "logout_urls" {
  description = "Logout URLs for the Cognito user pool client"
  type        = list(string)
}

