/*

Data lookup for userpool provider settings

*/

data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

data "aws_secretsmanager_secret" "provider_settings" {
  arn = "arn:aws:secretsmanager:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:secret:cognito-userpool-settings"
}

/*

Create Cognito User Pool

*/

resource "aws_cognito_user_pool" "this" {
  name             = var.aws_cognito_user_pool_name
  alias_attributes = var.alias_attributes


  account_recovery_setting {
    recovery_mechanism {
      name     = "admin_only" # Disable self-service account recovery via Cognito
      priority = 1
    }
  }

  admin_create_user_config {
    allow_admin_create_user_only = true # Disables self-service user sign-up via Cognito
  }

  schema {
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    name                     = "name"
    required                 = true
    string_attribute_constraints {
      min_length = 0
      max_length = 2048
    }
  }

  schema {
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    name                     = "email"
    required                 = true
    string_attribute_constraints {
      min_length = 0
      max_length = 2048
    }
  }

  schema {
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    name                     = "given_name"
    required                 = true
    string_attribute_constraints {
      min_length = 0
      max_length = 2048
    }
  }

  schema {
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    name                     = "family_name"
    required                 = true
    string_attribute_constraints {
      min_length = 0
      max_length = 2048
    }
  }

  schema {
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    name                     = "preferred_username"
    required                 = true
    string_attribute_constraints {
      min_length = 0
      max_length = 2048
    }
  }

  schema {
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    name                     = "usda_app_roles"
    required                 = false
    string_attribute_constraints {
      min_length = 0
      max_length = 2048
    }
  }

  schema {
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    name                     = "usda_ial"
    required                 = false
    string_attribute_constraints {
      min_length = 0
      max_length = 2048
    }
  }

  schema {
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    name                     = "usda_scims"
    required                 = false
    string_attribute_constraints {
      min_length = 0
      max_length = 2048
    }
  }

  schema {
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    name                     = "usda_usdaagencycode"
    required                 = false
    string_attribute_constraints {
      min_length = 0
      max_length = 2048
    }
  }

  schema {
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    name                     = "USDAEMPLOYEESTATUS"
    required                 = false
    string_attribute_constraints {
      min_length = 0
      max_length = 2048
    }
  }

  schema {
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    name                     = "usda_agency_code"
    required                 = false
    string_attribute_constraints {
      min_length = 0
      max_length = 2048
    }
  }

  schema {
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    name                     = "usda_employee_status"
    required                 = false
    string_attribute_constraints {
      min_length = 0
      max_length = 2048
    }
  }
}


resource "aws_cognito_user_pool_domain" "this" {
  domain       = var.aws_cognito_user_pool_domain
  user_pool_id = aws_cognito_user_pool.this.id
}


resource "aws_cognito_identity_provider" "this" {
  user_pool_id  = aws_cognito_user_pool.this.id
  provider_name = var.aws_cognito_identity_provider_name
  provider_type = var.aws_cognito_identity_provider_type

  provider_details = {
    authorize_scopes              = var.authorize_scopes
    client_id                     = jsondecode(data.aws_secretsmanager_secret_version.provider_settings.secret_string)["client_id"]
    client_secret                 = jsondecode(data.aws_secretsmanager_secret_version.provider_settings.secret_string)["client_secret"]
    attributes_request_method     = "POST"
    attributes_url                = jsondecode(data.aws_secretsmanager_secret_version.provider_settings.secret_string)["attributes_url"]
    attributes_url_add_attributes = "false"
    authorize_url                 = jsondecode(data.aws_secretsmanager_secret_version.provider_settings.secret_string)["authorize_url"]
    jwks_uri                      = jsondecode(data.aws_secretsmanager_secret_version.provider_settings.secret_string)["jwks_uri"]
    oidc_issuer                   = jsondecode(data.aws_secretsmanager_secret_version.provider_settings.secret_string)["oidc_issuer"]
    token_url                     = jsondecode(data.aws_secretsmanager_secret_version.provider_settings.secret_string)["token_url"]
  }

  attribute_mapping = {
    email                         = "email"
    username                      = "sub"
    family_name                   = "family_name"
    given_name                    = "given_name"
    name                          = "name"
    preferred_username            = "sub"
    "custom:usda_app_roles"       = "usda_app_roles"
    "custom:usda_scims"           = "usda_scims"
    "custom:usda_ial"             = "usda_ial"
    "custom:usdaagencycode"       = "usdaagencycode"
    "custom:USDAEMPLOYEESTATUS"   = "USDAEMPLOYEESTATUS"
    "custom:usda_agency_code"     = "usda_agency_code"
    "custom:usda_employee_status" = "usda_employee_status"
  }
}


/*

 Create resource server to associate with user pool
 Needed for custom scopes

*/

resource "aws_cognito_resource_server" "this" {
  identifier = "usda_credential_data"
  name       = "usda_credential_data"

  scope {
    scope_name        = "usda_credential_data"
    scope_description = "usda_credential_data"
  }

  user_pool_id = aws_cognito_user_pool.this.id
}


#Fetch the SAML metadata XML from AWS Secrets Manager
data "aws_secretsmanager_secret_version" "provider_settings" {
  secret_id = "cognito-userpool-settings"
}

#data "aws_secretsmanager_secret_version" "saml_metadata_version" {
 # secret_id = data.aws_secretsmanager_secret.saml_metadata.id
#}


# Create SAML Identity Provider
resource "aws_cognito_identity_provider" "saml_provider" {
  user_pool_id  = var.user_pool_id
  provider_name = var.aws_cognito_identity_provider_name
  provider_type = var.aws_cognito_identity_saml_provider_type


  provider_details = {
    attributes_request_method     = "POST"
    attributes_url_add_attributes = "false"
    authorize_url                 = jsondecode(data.aws_secretsmanager_secret_version.provider_settings.secret_string)["authorize_url"]
    MetadataXML                   = jsondecode(data.aws_secretsmanager_secret_version.provider_settings.secret_string)["saml2_metadata"]
    IDPEntityId                   = jsondecode(data.aws_secretsmanager_secret_version.provider_settings.secret_string)["IDPEntityId"]
    SSORedirectBindingURL         = jsondecode(data.aws_secretsmanager_secret_version.provider_settings.secret_string)["SSORedirectBindingURL"]
    cert_logout_url               = jsondecode(data.aws_secretsmanager_secret_version.provider_settings.secret_string)["cert_logout_url"]
    prod_logout_url               = jsondecode(data.aws_secretsmanager_secret_version.provider_settings.secret_string)["prod_logout_url"]
    
  }


  attribute_mapping = {
    email       = "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress"
    given_name  = "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/givenname"
    family_name = "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/surname"
    name        = "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name"
    username                      = "sub"
    preferred_username            = "sub"
    "custom:usda_app_roles"       = "usda_app_roles"
    "custom:usda_scims"           = "usda_scims"
    "custom:usda_ial"             = "usda_ial"
    "custom:usdaagencycode"       = "usdaagencycode"
    "custom:USDAEMPLOYEESTATUS"   = "USDAEMPLOYEESTATUS"
    "custom:usda_agency_code"     = "usda_agency_code"
    "custom:usda_employee_status" = "usda_employee_status"
  }

  lifecycle {
    ignore_changes = [provider_details]
  }
 
}
