# Terraform-K3d-ArgoCD


PURPOSE:
Provide an PLATFORM to allow for creation of ArgoCD Applications using a terraform module

THE PLATFORM
- Created with Terraform
    - K8s cluster running on K3D
    - Nginix Ingress Controller
    - ArgoCD 
        - with an Ingress to accept HTTPS connections
        - self-signed TLS certificate


THE TERRAFORM MODULE FOR ArgoCD Applications
- Creates an ArgoCD Application
    - uses a generice helm chart located at: https://github.com/b3outputs/helm-charts
    - uses a yaml file to pass values to the helm chart

EXAMPLE:
module "argocd_app" {
  source  = "./argocd_module"

  argo_project_name    = "my-special-project"
  argocd_namespace     = "argocd"
  apps_namespace       = "my-apps"
  app_name             = "myapp"
  helm_release_name    = "myapp-release"
  helm_values_path     = "./path/to/myapp-values.yaml"
}

output "project_name" {
  value = module.argocd_app.project_name
}


