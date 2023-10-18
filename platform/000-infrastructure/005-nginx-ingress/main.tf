
resource "helm_release" "nginx_ingress" {
  name       = "nginx-ingress"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  namespace  = "kube-system" 
  version    = "4.7.3" 

  set {
    name  = "controller.service.type"
    value = "ClusterIP"
  }
}