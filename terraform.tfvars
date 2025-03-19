# AWS Region
aws_region = "us-east-1"  # Change if using a different region

# Cognito User Pool Information
user_pool_id = "us-east-1_zwd2dAHfx"  # Replace with your actual Cognito User Pool ID
user_pool_name        = "ExistingDataZoneUserPool"
user_pool_client_name = "DataZoneAppClient"

# SAML Identity Provider for Cognito
saml_provider_name = "eAuth-ICAM-SAML"
saml_metadata_url  = "https://eauth-icam-metadata-url"  # Replace with actual SAML metadata URL

# Callback and Logout URLs for Cognito Authentication
callback_urls = ["https://dzd_581xa3qdroeazr.datazone.us-east-1.on.aws/callback"]
logout_urls   = ["https://dzd_581xa3qdroeazr.datazone.us-east-1.on.aws/logout"]
