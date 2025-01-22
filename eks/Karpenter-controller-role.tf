data "aws_iam_policy_document" "karpernter_controller_assume_role_policy"{
    statement {
      actions = [ "sts:AssumeRoleWithWebIdentity"]
        effect = "Allow"

        condition {
        test = "StringEquals"
        variable = "${replace(aws_eks_cluster.eks_cluster.identity.0.oidc.0.issuer, "https://", "")}:sub"
        values = ["system:serviceaccount:karpenter:karpenter"]
        }

        principals {
        type = "Federated"
        identifiers = [aws_iam_openid_connect_provider.eks.arn]
        }
    
    }
}

resource "aws_iam_role" "karpernter_controller" {
    assume_role_policy = data.aws_iam_policy_document.karpenter_controller_assume_role_policy.json
    name               = "karpenter-controller"
}

resource "aws_iam_policy" "karpenter_controller" {
  policy = file("${path.module}/../values/controller-trust-policy.json")
  name   = "KarpenterController"
}

resource "aws_iam_role_policy_attachment" "aws_load_balancer_controller_attach" {
  role       = aws_iam_role.karpenter_controller.name
  policy_arn = aws_iam_policy.karpenter_controller.arn
}

resource "aws_iam_instance_profile" "karpenter" {
  name = "KarpenterNodeInstanceProfile"
  role = aws_iam_role.nodes.name
}