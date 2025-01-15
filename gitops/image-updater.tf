# helm repo add argo https://argoproj.github.io/argo-helm
# helm repo update
# helm install updater -n argocd argo/argocd-image-updater --version 0.8.4 -f terraform/values/image-updater.yaml

data "aws_iam_policy_document" "argocd_image_updater" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["pods.eks.amazonaws.com"]
    }

    actions = [
      "sts:AssumeRole",
      "sts:TagSession",
    ]
  
}
}

resource "aws_iam_role" "argocd_image_updater" {
  name               = "${var.eks_cluster_name}-argocd-image-updater"
  assume_role_policy = data.aws_iam_policy_document.argocd_image_updater.json
}

resource "aws_iam_role_policy_attachment" "argocd_image_updater" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.argocd_image_updater.name
}

resource "aws_eks_pod_identity_association" "argocd_image_updater" {
  cluster_name    = var.eks_cluster_name
  namespace       = "argocd"
  service_account = "argocd-image-updater"
  role_arn        = aws_iam_role.argocd_image_updater.arn
}

resource "helm_release" "updater" {

  count = var.enable_argo_cd_image_updater == true ? 1 : 0
  name = "updater"

  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argocd-image-updater"
  namespace        = "argocd"
  create_namespace = false
  version          = "0.11.0"

  values = [file("${path.module}/../values/image-updater.yaml")]

  depends_on = [ helm_release.argo_cd ]
}

