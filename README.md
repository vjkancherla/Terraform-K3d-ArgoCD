# Terraform-K3d-ArgoCD

## Purpose

Provide a platform to allow for the creation of ArgoCD Applications using a Terraform module.

## The Platform

- **Infrastructure**: Created with Terraform
    - **Kubernetes**: K8s cluster running on K3D
    - **Ingress Controller**: Nginix Ingress Controller
    - **ArgoCD**: 
        - Features an Ingress to accept HTTPS connections
        - Uses a self-signed TLS certificate

## The Terraform Module for ArgoCD Applications

- **Functionality**: Creates an ArgoCD Application
    - Utilizes a generic Helm chart available at [b3outputs/helm-charts](https://github.com/b3outputs/helm-charts)
    - Employs a yaml file to pass values to the Helm chart

## Example

```hcl
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
 
