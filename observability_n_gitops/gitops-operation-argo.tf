resource "helm_release" "argo_cd" {
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


