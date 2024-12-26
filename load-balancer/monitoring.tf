resource "helm_release" "prometheus" {
  name       = "prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "prometheus"
  namespace  = "monitoring"

  create_namespace = true # Ensures the namespace is created if it doesn't exist

  set {
    name  = "server.service.type"
    value = "ClusterIP"
  }

  set {
    name  = "alertmanager.enabled"
    value = true
  }

  set {
    name  = "pushgateway.enabled"
    value = true
  }

  set {
    name  = "server.persistentVolume.enabled"
    value = true # Set to true if persistent storage is required
  }
  set {
    name = "clusterName"
    value = var.eks_cluster_name
  }
}

resource "helm_release" "grafana" {
  name       = "grafana"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "grafana"
  namespace  = "monitoring"

  set {
    name = "clusterName"
    value = var.eks_cluster_name
  }
  set {
    name  = "adminUser"
    value = "admin" # Default Grafana admin username
  }

  set {
    name  = "adminPassword"
    value = "securepassword" # Replace with a secure password
  }

  set {
    name  = "service.type"
    value = "ClusterIP" # Use LoadBalancer if external access is required
  }

  set {
    name  = "persistence.enabled"
    value = false # Set to true if persistent storage is required
  }

  depends_on = [helm_release.prometheus] # Ensure Prometheus is installed first
}
