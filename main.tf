module "cognito" {
  source = "./modules/cognito"

  user_pool_id            = var.user_pool_id
  user_pool_name          = var.user_pool_name
  user_pool_client_name   = var.user_pool_client_name
  saml_provider_name      = var.saml_provider_name
  saml_metadata_url       = var.saml_metadata_url
  callback_urls           = var.callback_urls
  logout_urls             = var.logout_urls
  iam_role_name           = var.iam_role_name
  policy_name             = var.policy_name
}
