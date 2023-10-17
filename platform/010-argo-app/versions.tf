terraform {
  required_version = ">= 1.3"

  required_providers {
    argocd = {
      source  = "oboukili/argocd"
      version = ">= 6"
    }
  }
}

provider "argocd" {
  insecure    = true # Trust self-signed certificate
  server_addr = "argocd.127.0.0.1.nip.io:8080"
  username    = "admin"
  password    = "password"
}
