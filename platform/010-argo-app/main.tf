locals {
  argo_project_name = "mytestproject"
  argocd_namespace = "argocd"
  apps_namespace = "apps"
}

resource "kubernetes_namespace" "apps_ns" {
  metadata {
    name = local.apps_namespace
  }
}

resource "argocd_project" "myproject" {
  metadata {
    name      = local.argo_project_name
    namespace = local.argocd_namespace
    labels = {
      acceptance = "true"
    }
    annotations = {
      "this.is.a.really.long.nested.key" = "yes, really!"
    }
  }

  spec {
    description = "simple project"

    source_namespaces = ["*"]
    source_repos      = ["*"]

    destination {
      server    = "*"
      namespace = "*"
    }
  }
}

resource "argocd_application" "helm" {
  depends_on = [ 
      kubernetes_namespace.apps_ns,
      argocd_project.myproject
    ]

  metadata {
    name      = "podinfo"
    namespace = local.argocd_namespace
    labels = {
      test = "true"
    }
  }

  spec {
    project = "default" #local.argo_project_name
    
    destination {
      server    = "https://kubernetes.default.svc"
      namespace = local.apps_namespace
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

    sync_policy {
      automated {
        prune       = true
        self_heal   = true
        allow_empty = true
      }
      sync_options = ["Validate=false"]
      retry {
        limit = "5"
        backoff {
          duration     = "30s"
          max_duration = "2m"
          factor       = "2"
        }
      }
    }
  }
}