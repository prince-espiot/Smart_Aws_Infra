#NEED TO CLEAN UP THE CODE
resource "helm_release" "kube_prometheus_stack" {
  name             = "kube-prometheus-stack"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  namespace        = "monitoring"
  create_namespace = true # Ensures the namespace is created if it doesn't exist

  values = [
    file("${path.module}/../values/custom-values.yaml") # Reference to the custom values YAML file
  ]

  # You can also set individual values here if needed
  set {
    name  = "clusterName"
    value = var.eks_cluster_name
  }

  /* set {
    name  = "prometheus.prometheusSpec.storageSpec.volumeClaimTemplate.spec.storageClassName"
    value = "gp2" # Set the storage class to gp2
  }

  set {
    name  = "prometheus.prometheusSpec.storageSpec.volumeClaimTemplate.spec.resources.requests.storage"
    value = "50Gi" # Set the size of the persistent volume
  }

  set {
    name  = "grafana.adminPassword"
    value = "securepassword" # Replace with a secure password
  } */

 # depends_on = [null_resource.namespace_monitoring] # Ensure the namespace is created
}

/* # Optional: Create the namespace manually using Terraform
resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
  }
}

# Define dependency for the namespace
resource "null_resource" "namespace_monitoring" {
  depends_on = [kubernetes_namespace.monitoring]
}
 */