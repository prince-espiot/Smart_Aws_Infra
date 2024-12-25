/*

resource "aws_iam_role_policy_attachment" "aws_ingress_attach" {
  policy_arn = aws_iam_policy.aws_ingress.arn
  role       = aws_iam_role.eks_nodes.name
}


resource "aws_iam_role" "eks_nodes" {
  name = "${var.cluster_name}-worker"

  assume_role_policy = data.aws_iam_policy_document.assume_workers.json
}

data "aws_iam_policy_document" "assume_workers" {
  statement {
    effect = "Allow"

    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# OIDC Provider for IRSA
data "aws_eks_cluster" "cluster" {
  name = aws_eks_cluster.eks_cluster.name
}

data "aws_eks_cluster_auth" "cluster" {
  name = aws_eks_cluster.eks_cluster.name
}

resource "aws_iam_openid_connect_provider" "oidc_provider" {
  client_id_list   = ["sts.amazonaws.com"]
  thumbprint_list  = ["9e99a48a9960b14926bb7f3b3aab9027c7980727"] # Adjust as necessary
  url              = aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer
}

data "aws_iam_policy_document" "eks_assume_role" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.oidc_provider.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:aws-node"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.oidc_provider.arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "eks_addon_role" {
  name = "eks-addon-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      },
      {
        Effect = "Allow"
        Principal = {
          Federated = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer}"
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "${data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer}:sub" = "system:serviceaccount:kube-system:ebs-csi-controller-sa"
          }
        }
      }
    ]
  })

  tags = {
    Name = "eks-addon-role"
  }
}

data "aws_caller_identity" "current" {}

resource "aws_iam_role_policy" "eks_addon_policy" {
  name   = "eks-addon-policy"
  role   = aws_iam_role.eks_addon_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "eks:UpdateAddon",
          "eks:DescribeAddon",
          "eks:DescribeCluster",
          "iam:PassRole",
          "ec2:DescribeInstances",
          "ec2:AttachVolume"
        ]
        Resource = "*"
      }
    ]
  })
}

# Security group associated with eks
resource "aws_security_group" "public_sg" {
  name   = "public-sg-for-eks"
  vpc_id = var.vpc_id

  tags = {
    Name = "public-sg-for-eks"
  }
}

resource "aws_security_group_rule" "sg_egress_public" {
  security_group_id = aws_security_group.public_sg.id
  type              = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group" "data_plane_sg" {
  name   = "kuber-data-plane-sg"
  vpc_id = var.vpc_id

  tags = {
    Name = "kuber-data-plane-sg"
  }
}

# Node Sec-group
resource "aws_security_group_rule" "nodes" {
  description              = "Allow nodes to communicate with each other"
  security_group_id = aws_security_group.data_plane_sg.id
  type              = "ingress"
  from_port   = 0
  to_port     = 65535
  protocol    = "-1"
  cidr_blocks = flatten([var.private_subnet_cidrs, var.public_subnet_cidrs])
}

resource "aws_iam_role" "eks_iam_role" {
  assume_role_policy = data.aws_iam_policy_document.eks_assume_role.json
  name               = "${var.cluster_name}-eks"
}

resource "aws_security_group_rule" "nodes_inbound" {
  description              = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
  security_group_id = aws_security_group.data_plane_sg.id
  type              = "ingress"
  from_port   = 1025
  to_port     = 65535
  protocol    = "tcp"
  cidr_blocks = flatten([var.private_subnet_cidrs])
}

resource "aws_security_group_rule" "node_outbound" {
  security_group_id = aws_security_group.data_plane_sg.id
  type              = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

# SG for control plane 
resource "aws_security_group" "control_plane_sg" {
  name   = "kuber-control-plane-sg"
  vpc_id = var.vpc_id

  tags = {
    Name = "kuber-control-plane-sg"
  }
}

resource "aws_security_group_rule" "control_plane_inbound" {
  security_group_id = aws_security_group.control_plane_sg.id
  type              = "ingress"
  from_port   = 0
  to_port     = 65535
  protocol    = "tcp"
  cidr_blocks = flatten([var.private_subnet_cidrs, var.public_subnet_cidrs])
}

resource "aws_security_group_rule" "control_plane_outbound" {
  security_group_id = aws_security_group.control_plane_sg.id
  type              = "egress"
  from_port   = 0
  to_port     = 65535
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}



resource "aws_security_group_rule" "cluster_inbound" {
  description              = "Allow worker nodes to communicate with the cluster API Server"
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_cluster.id
  source_security_group_id = aws_security_group.eks_nodes.id
  to_port                  = 443
  type                     = "ingress"
}

resource "aws_security_group_rule" "cluster_outbound" {
  description              = "Allow cluster API Server to communicate with the worker nodes"
  from_port                = 1024
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_cluster.id
  source_security_group_id = aws_security_group.eks_nodes.id
  to_port                  = 65535
  type                     = "egress"
}



resource "aws_iam_policy" "aws_ingress" {
  policy = file("${path.module}/aws_ingress_policy.json")
}

resource "aws_eks_addon" "cni" {
  cluster_name = var.cluster_name
  addon_name   = "vpc-cni"
  depends_on   = [aws_eks_cluster.eks_cluster]
}

resource "aws_eks_addon" "kube-proxy" {
  cluster_name = var.cluster_name
  addon_name   = "kube-proxy"
  depends_on   = [aws_eks_cluster.eks_cluster]
}

resource "aws_eks_addon" "coredns" {
  cluster_name = var.cluster_name
  addon_name   = "coredns"
  depends_on   = [aws_eks_cluster.eks_cluster, aws_eks_node_group.eks_nodes]
}

resource "aws_eks_addon" "ebs" {
  cluster_name             = var.cluster_name
  addon_name               = "aws-ebs-csi-driver"
  service_account_role_arn = aws_iam_role.eks_addon_role.arn
  depends_on               = [aws_eks_cluster.eks_cluster]
}


*/