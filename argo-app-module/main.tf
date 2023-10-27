locals {
  argo_project_name = var.argo_project_name
  argocd_namespace  = var.argocd_namespace
  apps_namespace    = var.apps_namespace

  helm_values = var.helm_values_content == "" ? file("${path.module}/app-values.yaml") : var.helm_values_content
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
    name      = var.app_name
    namespace = local.argocd_namespace
    labels = {
      test = "true"
    }
  }

  spec {
    project = local.argo_project_name
    
    destination {
      server    = "https://kubernetes.default.svc"
      namespace = local.apps_namespace
    }

    source {
      repo_url        = var.app_repo_url
      path            = var.app_path
      target_revision = var.app_target_revision
      helm {
        release_name = var.helm_release_name
        values       = local.helm_values
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
