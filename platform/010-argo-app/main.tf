module "app" {
  source  = "rallyware/apps/argocd"
  version = "0.2.2"

  apps = [
    {
      name           = "podinfo"
      namespace      = "apps"
      chart          = "charts/generic-app/"
      repository     = "https://github.com/b3outputs/helm-charts"
      version        = "generic-app-v0.1.6"
      project        = "aweasome-project"
      cluster        = "in-cluster"
      max_history    = 5

      sync_options = [
        "CreateNamespace=true", 
        "ApplyOutOfSyncOnly=true",
        "ServerSideApply=true"
      ]
      
      value_files = [
        file("${path.module}/app-values.yaml")
      ]
      
    }
  ]

  parent_app = {
    name = "the-app-of-apps"
    namespace = "apps"
  }

  name      = "aweasome"
  stage     = "production"
  namespace = "argo-cd"
}