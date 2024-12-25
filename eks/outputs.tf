# EKS Module
output "cluster_name" {
  description = "The name of the EKS cluster"
  value       = aws_eks_cluster.eks_cluster.name
}

# Outputs
output "eks_cluster_endpoint" {
  value = aws_eks_cluster.eks_cluster.endpoint
}

output "eks_cluster_arn" {
  value = aws_eks_cluster.eks_cluster.arn
}

output "eks_node_role_arn" {
  value = aws_iam_role.eks_node_group_role.arn
}

