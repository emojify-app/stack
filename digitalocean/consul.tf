resource "helm_release" "consul" {
  depends_on = ["kubernetes_cluster_role_binding.tiller"]

  name    = "consul"
  chart   = "${path.module}/helm-charts/consul-helm-0.5.0"
  timeout = 300

  set {
    name  = "version"
    value = "0.5.0"
  }

  set {
    name  = "ui.enabled"
    value = true
  }

  set {
    name  = "syncCatalog.enabled"
    value = true
  }

  set {
    name  = "connectInject.enabled"
    value = true
  }

  set {
    name  = "client.grpc"
    value = true
  }

  set {
    name  = "client.enabled"
    value = true
  }

  set {
    name  = "server.enabled"
    value = true
  }

  set {
    name  = "dns.enabled"
    value = true
  }
}
