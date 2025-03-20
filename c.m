/*

  Create Cognito App Client in "mgmt" account. 
  Also creates a secret in your mission area account containing the app client details (client_id, cilent_secret, endpoint_urls etc.)
  
  This requires you to declare an AWS provider with the alias "mgmt" in your workspace.

  Depending on the environment this App Client resides in, use one of the following assume_role.role_arn values below for your "mgmt" provider:

  -- NonProd/CERT eAuth --
  
  assume_role {
    role_arn = "arn:aws:iam::473847675421:role/USDA-FPAC_FBC-NonProdTechnical-TFE"
  }

  -- Production eAuth --

  assume_role {
    role_arn = "arn:aws:iam::184475962197:role/USDA-FPAC_MGMT-PRD-TFE"
  }

  See "Examples" folder for more info.

*/

data "terraform_remote_state" "userpool" {
  backend = "remote"

  config = {
    hostname     = "terraform.fpac.usda.gov"
    organization = "FPAC"
    workspaces = {
      name = "tfws-aws-fbc-cognito-${var.eauth_environment}"
    }
  }
}

locals {
  appclient_settings_secret_name = "${var.eauth_environment}/cognito/${var.name}/appclient-properties"

  default_logout_url = var.eauth_environment == "cert" ? "https://www.cert.eauth.usda.gov/Logout/logoff.asp" : "https://www.eauth.usda.gov/Logout/logoff.asp"
  logout_urls        = coalesce(var.logout_urls, { eauth = local.default_logout_url })                    # If no logout URLs are provided, use eAuth to logout.
  logout_urls_list   = [for url_key, url_val in local.logout_urls : url_val]                              # List of logout URL values
  logout_urls_map    = { for url_key, url_val in local.logout_urls : "logout_url_${url_key}" => url_val } # Map of logout URLs with "logout_url_" prefix in key (to be used in secret)
}

resource "aws_cognito_user_pool_client" "this" {
  provider                                      = aws.cognito
  name                                          = var.name
  callback_urls                                 = var.callback_urls
  logout_urls                                   = local.logout_urls_list
  default_redirect_uri                          = var.default_redirect_uri
  user_pool_id                                  = data.terraform_remote_state.userpool.outputs.id
  allowed_oauth_flows                           = var.allowed_oauth_flows
  allowed_oauth_scopes                          = var.allowed_oauth_scopes
  allowed_oauth_flows_user_pool_client          = var.allowed_oauth_flows_user_pool_client
  auth_session_validity                         = var.auth_session_validity
  enable_propagate_additional_user_context_data = var.enable_propagate_additional_user_context_data
  enable_token_revocation                       = var.enable_token_revocation
  explicit_auth_flows                           = var.explicit_auth_flows
  access_token_validity                         = var.access_token_validity
  supported_identity_providers                  = var.supported_identity_provider == null ? ["usda-fpac-cognito-${var.eauth_environment}"] : [var.supported_identity_provider]
  generate_secret                               = var.generate_secret
  # user_pool_client_name                       = var.user_pool_client_name
  #saml_provider_name                           = var.saml_provider_name
  #saml_metadata_url                            = var.saml_metadata_url
  #callback_urls                                = var.callback_urls
  #logout_urls                                  = var.logout_urls
  #iam_role_name                                = var.iam_role_name
  #policy_name                                  = var.policy_name
  token_validity_units {
    access_token = "minutes"
  }
}

/*

# Create SAML Identity Provider
resource "aws_cognito_identity_provider" "saml_provider" {
  user_pool_id  = data.aws_cognito_user_pool.existing_userpool.id (Replace with No 53)
  provider_name = var.saml_provider_name
  provider_type = "SAML"

  provider_details = {
  MetadataFile = <<EOT
  <EntityDescriptor xmlns="urn:oasis:names:tc:SAML:2.0:metadata" ... >
    <!-- Paste your actual SAML XML metadata content here -->
  </EntityDescriptor>
  EOT
}


  attribute_mapping = {
    email       = "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress"
    given_name  = "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/givenname"
    family_name = "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/surname"
    name        = "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name"
  }

  lifecycle {
    ignore_changes = [provider_details]
  }
}

# Update Cognito User Pool Client to Support SAML
resource "aws_cognito_user_pool_client" "cognito_client" {
  user_pool_id = data.aws_cognito_user_pool.existing_userpool.id
  name         = var.user_pool_client_name

  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows = ["implicit", "code"]
  allowed_oauth_scopes = ["openid", "email", "profile"]
  supported_identity_providers = [
    aws_cognito_identity_provider.saml_provider.provider_name
  ]

  callback_urls = var.callback_urls
  logout_urls   = var.logout_urls
}

# IAM Role for Cognito-Authenticated Users
resource "aws_iam_role" "cognito_authenticated_role" {
  name = var.iam_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Federated = "cognito-identity.amazonaws.com"
      }
      Action = "sts:AssumeRoleWithWebIdentity"
      Condition = {
        StringEquals = {
          "cognito-identity.amazonaws.com:aud" = data.aws_cognito_user_pool.existing_userpool.id
        }
      }
    }]
  })
}

# IAM Policy to Allow Access to DataZone
resource "aws_iam_policy" "datazone_access_policy" {
  name        = var.policy_name
  description = "Policy for allowing access to DataZone Portal"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = [
        "datazone:GetDataPortal",
        "datazone:ListDomains",
        "datazone:AccessData"
      ]
      Resource = "*"
    }]
  })
}

# Attach IAM Policy to Cognito-Authenticated Role
resource "aws_iam_role_policy_attachment" "cognito_policy_attach" {
  role       = aws_iam_role.cognito_authenticated_role.name
  policy_arn = aws_iam_policy.datazone_access_policy.arn
}
*/

/*

  Output User Pool Client information to Mission Area AWS account.

*/

module "appclient-settings" {
  providers = {
    aws = aws.mission
  }
  source = "terraform.fpac.usda.gov/FPAC/security/aws//modules/secrets-manager"
  secrets = {
    "${local.appclient_settings_secret_name}" = {
      description = "Cognito App Client information for ${var.name}"
      secret_key_value = merge(local.logout_urls_map, { # logout_urls are merged with "logout_url_" prefix in key
        user_pool_id           = data.terraform_remote_state.userpool.outputs.id
        redirect_uri           = var.default_redirect_uri
        client_name            = "${aws_cognito_user_pool_client.this.name}"
        client_id              = "${aws_cognito_user_pool_client.this.id}"
        client_secret          = "${aws_cognito_user_pool_client.this.client_secret}"
        cognito_domain         = data.terraform_remote_state.userpool.outputs.domain
        openid_configuration   = data.terraform_remote_state.userpool.outputs.wellknown_endpoint
        authorization_endpoint = data.terraform_remote_state.userpool.outputs.authorization_endpoint
        end_session_endpoint   = data.terraform_remote_state.userpool.outputs.end_session_endpoint
        issuer                 = data.terraform_remote_state.userpool.outputs.issuer
        jwks_uri               = data.terraform_remote_state.userpool.outputs.jwks_uri
        revocation_endpoint    = data.terraform_remote_state.userpool.outputs.revocation_endpoint
        token_endpoint         = data.terraform_remote_state.userpool.outputs.token_endpoint
        userinfo_endpoint      = data.terraform_remote_state.userpool.outputs.userinfo_endpoint
      })
      recovery_window_in_days = 7
    }
  }
  tags = var.tags
}
