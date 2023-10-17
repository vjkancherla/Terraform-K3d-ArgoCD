
locals {
  argocd_hostname = "argocd.127.0.0.1.nip.io"
  argocd_secret_name = "argocd-tls"
  argocd_namespace = "argocd"
}

resource "tls_private_key" "self_signed_cert" {
  algorithm   = "RSA"
  rsa_bits    = 2048
}

resource "tls_self_signed_cert" "self_signed_cert" {
  key_algorithm   = "RSA"
  private_key_pem = tls_private_key.self_signed_cert.private_key_pem

  subject {
    common_name  = local.argocd_hostname
  }

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]

  validity_period_hours = 8760  # Valid for one year
}

resource "kubernetes_namespace" "argocd_namespace" {
  metadata {
    name = local.argocd_namespace
  }
}

resource "kubernetes_secret" "argocd_tls" {
  depends_on = [kubernetes_namespace.argocd_namespace]

  metadata {
    name = local.argocd_secret_name
    namespace = local.argocd_namespace
  }

  data = {
    "tls.crt" = tls_self_signed_cert.self_signed_cert.cert_pem
    "tls.key" = tls_private_key.self_signed_cert.private_key_pem
  }
}

# Argo requires the password to be bcrypt, we use custom provider of bcrypt,
# as the default bcrypt function generates diff for each terraform plan
resource "bcrypt_hash" "argo" {
  cleartext = "password"
}

# module "argocd" {
#   depends_on = [kubernetes_secret.argocd_tls]

#   source  = "squareops/argocd/kubernetes"
#   version = "2.0.0"

#   argocd_config = {
#     hostname                     = local.argocd_hostname
#     redis_ha_enabled             = false
#     autoscaling_enabled          = false
#     slack_notification_token     = ""
#     argocd_notifications_enabled = false

#     values_yaml = templatefile(
#       "${path.module}/helm-values.yaml.tftpl",
#       { 
#         admin_password = bcrypt_hash.argo.id 
#         argocd_hostname = local.argocd_hostname
#         argocd_tls_secret = kubernetes_secret.argocd_tls.name
#       }
#     )
#   }
# }

resource "helm_release" "argocd" {
  depends_on = [kubernetes_secret.argocd_tls]

  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  namespace  = local.argocd_namespace
  version    = "5.46.8" 

  values = [
    templatefile(
      "${path.module}/helm-values.yaml.tftpl",
      { 
        admin_password = bcrypt_hash.argo.id 
        argocd_hostname = local.argocd_hostname
        argocd_tls_secret = local.argocd_secret_name
      }
    )
  ]
}