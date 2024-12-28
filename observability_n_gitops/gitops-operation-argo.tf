resource "helm_release" "argo_cd" {
  name       = "argo-cd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  namespace  = "argocd"

  create_namespace = true

  set {
    name  = "server.service.type"
    value = "ClusterIP"
  }

  set {
    name  = "server.service.annotations"
    value = "{service.beta.kubernetes.io/aws-load-balancer-internal: \"true\"}"
  }

  set {
    name  = "redis.enabled"
    value = "true"
  }

  set {
    name  = "server.extraArgs[0]"
    value = "--insecure"
  }

  set {
    name  = "configs.cm.repositories"
    value = "[{\"url\": \"https://github.com/prince-espiot/Test_deployment.git\"}]"
  }
set {
    name  = "configs.cm.application.instanceLabelKey"
    value = "argocd.argoproj.io/instance"
}

set {
    name  = "configs.cm.kustomize.buildOptions"
    value = "--load_restrictor none"
}

set {
    name  = "configs.cm.kustomize.paths"
    value = "[{\"path\": \"Test_deployment/Test-infra/Staging/test/kustomization.yaml\"}]"
}
  
}