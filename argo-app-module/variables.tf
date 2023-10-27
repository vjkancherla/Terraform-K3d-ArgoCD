variable "argo_project_name" {
  description = "Name of the ArgoCD project"
  type        = string
  default     = "mytestproject"
}

variable "argocd_namespace" {
  description = "Namespace for ArgoCD"
  type        = string
  default     = "argocd"
}

variable "apps_namespace" {
  description = "Namespace for the apps"
  type        = string
  default     = "apps"
}

variable "app_name" {
  description = "Name of the ArgoCD application"
  type        = string
  default     = "podinfo"
}

variable "app_repo_url" {
  description = "URL of the repository for the application"
  type        = string
  default     = "https://github.com/b3outputs/helm-charts"
}

variable "app_path" {
  description = "Path in the repository for the application"
  type        = string
  default     = "charts/generic-app/"
}

variable "app_target_revision" {
  description = "Target revision for the application"
  type        = string
  default     = "generic-app-v0.1.6"
}

variable "helm_release_name" {
  description = "Helm release name"
  type        = string
  default     = "podinfo-terraform"
}

variable "helm_values_content" {
  description = "YAML values for the Helm release"
  type        = string
  default     = ""
}


