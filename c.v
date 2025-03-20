variable "allowed_oauth_flows" {
  description = "OAUTH flows allowed use for app client."
  type        = list(string)
  default     = ["code"]
}

variable "access_token_validity" {
  description = " (Optional) Time limit, between 5 minutes and 1 day, after which the access token is no longer valid and cannot be used. By default, the unit is hours. The unit can be overridden by a value in token_validity_units.access_token."
  type        = number
  default     = 60
}

variable "allowed_oauth_flows_user_pool_client" {
  type        = bool
  description = "Whether the client is allowed to follow the OAuth protocol when interacting with Cognito user pools."
  default     = true
}

variable "allowed_oauth_scopes" {
  description = "OAUTH scopes allowed use for app client."
  type        = list(string)
  default     = ["email", "openid", "phone", "profile", "aws.cognito.signin.user.admin", "usda_credential_data/usda_credential_data"]
}

variable "auth_session_validity" {
  description = "Amazon Cognito creates a session token for each API request in an authentication flow. AuthSessionValidity is the duration, in minutes, of that session token. Your user pool native user must respond to each authentication challenge before the session expires."
  type        = number
  default     = 3
}

variable "callback_urls" {
  type        = list(string)
  description = "List of callback URLs for this app"
  default     = null
}

variable "default_redirect_uri" {
  description = "Redirect URL for post-authentication flow (string)"
  type        = string
  default     = null
}

variable "enable_token_revocation" {
  type        = bool
  description = "Enables or disables token revocation."
  default     = true
}

variable "enable_propagate_additional_user_context_data" {
  type        = bool
  description = "Activates the propagation of additional user context data."
  default     = false
}

variable "eauth_environment" {
  type        = string
  description = "eAuth environment to use. (cert or prod)"
  validation {
    condition     = contains(["cert", "prod"], var.eauth_environment)
    error_message = "Valid value for eauth_environment is one of the following: cert, prod."
  }
}

variable "explicit_auth_flows" {
  type        = list(string)
  description = "List of authentication flows (ADMIN_NO_SRP_AUTH, CUSTOM_AUTH_FLOW_ONLY, USER_PASSWORD_AUTH, ALLOW_ADMIN_USER_PASSWORD_AUTH, ALLOW_CUSTOM_AUTH, ALLOW_USER_PASSWORD_AUTH, ALLOW_USER_SRP_AUTH, ALLOW_REFRESH_TOKEN_AUTH)."
  default     = []
}

variable "generate_secret" {
  type        = bool
  description = "Whether to generate a client secret for this app"
  default     = true
}

variable "logout_urls" {
  type        = map(string)
  description = "Map of logout URLs for this app"
  default     = null
}

variable "name" {
  type        = string
  description = "Name for your app client, should be {MISSION}-{ENV}-{APP}-{COMPONENT} (component is optional)"
  default     = null
}

variable "supported_identity_provider" {
  description = "Identity provider to use for app client."
  type        = string
  default     = null
}

variable "tags" {
  description = "Map of tags for Cognito secret."
  type        = map(string)
  default     = {}
}

/*

variable "aws_cognito_user_pool_name" {
  type        = string
  description = "Name for Cognito user pool"
  default     = null
}

variable "user_pool_client_name" {
  description = "Cognito User Pool Client Name"
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

*/
