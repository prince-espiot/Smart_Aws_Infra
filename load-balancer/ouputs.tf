output "aws_lbc_role_name" {
  description = "The IAM role name for the AWS Load Balancer Controller"
  value       = aws_iam_role.aws_lbc.name
}

output "aws_lbc_policy_name" {
  description = "The IAM policy name for the AWS Load Balancer Controller"
  value       = aws_iam_policy.aws_lbc.name
}

/*output "cluster_autoscaler_release" {
  value = helm_release.cluster_autoscaler
}*/