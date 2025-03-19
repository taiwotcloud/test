# Fetch existing Cognito User Pool
data "aws_cognito_user_pool" "existing_userpool" {
  user_pool_id = var.user_pool_id
}



# Create SAML Identity Provider
resource "aws_cognito_identity_provider" "saml_provider" {
  user_pool_id  = data.aws_cognito_user_pool.existing_userpool.id
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
