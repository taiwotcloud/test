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
}variable "aws_cognito_user_pool_name" {
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
