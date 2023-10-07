# Argo requires the password to be bcrypt, we use custom provider of bcrypt,
# as the default bcrypt function generates diff for each terraform plan
resource "bcrypt_hash" "argo" {
  cleartext = "password"
}

module "argocd" {
  source  = "squareops/argocd/kubernetes"
  version = "2.0.0"

  argocd_config = {
    hostname                    = "argocd.localhost"
    redis_ha_enabled            = false
    autoscaling_enabled         = false
    slack_notification_token    = ""
    argocd_notifications_enabled = false  

    values_yaml = templatefile(
        "${path.module}/helm-values.yaml.tftpl", 
        { admin_password = bcrypt_hash.argo.id }
    )
  }
}