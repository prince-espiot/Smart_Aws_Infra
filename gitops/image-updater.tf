# helm repo add argo https://argoproj.github.io/argo-helm
# helm repo update
# helm install updater -n argocd argo/argocd-image-updater --version 0.8.4 -f terraform/values/image-updater.yaml
resource "helm_release" "updater" {

  count = var.enable_argo_cd_image_updater == true ? 1 : 0
  name = "updater"

  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argocd-image-updater"
  namespace        = "argocd"
  create_namespace = false
  version          = "0.11.4"

  values = [file("${path.module}/../values/image-updater.yaml")]

  depends_on = [ helm_release.argo_cd ]
}