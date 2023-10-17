resource "argocd_application" "helm" {
  metadata {
    name      = "podinfo"
    namespace = "argocd"
    labels = {
      test = "true"
    }
  }

  spec {
    destination {
      server    = "https://kubernetes.default.svc"
      namespace = "apps"
    }

    source {
      repo_url        = "https://github.com/b3outputs/helm-charts"
      path            = "charts/generic-app/"
      target_revision = "generic-app-v0.1.6"
      helm {
        release_name = "podinfo-terraform"
        values = file("${path.module}/app-values.yaml")
      }
    }
  }
}