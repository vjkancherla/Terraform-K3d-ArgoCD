terraform {
  required_version = ">= 1.3"

  required_providers {
    argocd = {
      source  = "oboukili/argocd"
      version = ">= 6"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

provider "argocd" {
  insecure    = true # Trust self-signed certificate
  server_addr = "argocd.127.0.0.1.nip.io:8443" # k port-forward -n kube-system svc/nginx-ingress-ingress-nginx-controller 8443:443
  username    = "admin"
  password    = "password"
}
