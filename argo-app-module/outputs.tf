output "created_namespace" {
  description = "The created namespace for the apps"
  value       = kubernetes_namespace.apps_ns.metadata[0].name
}

output "created_argocd_application" {
  description = "The created ArgoCD application name"
  value       = argocd_application.helm.metadata[0].name
}
