resource "helm_release" "argo_cd" {
  count = var.enable_argo_cd == true ? 1 : 0
  name       = "argo-cd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  namespace  = "argocd"
  version    = "7.7.15"

  create_namespace = true

  values = [
    file("${path.module}/../values/argocd.yaml"),
  ]

   
}


