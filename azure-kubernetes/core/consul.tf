# Run consul on kubernetes
resource "helm_release" "consul" {
  count = "${var.consul_enabled == true ? 1 : 0}"

  name    = "consul"
  chart   = "${path.module}/helm_charts/consul-helm"
  timeout = 1000

  set {
    name  = "version"
    value = "0.3.0"
  }

  set {
    name  = "dns.enabled"
    value = true
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
    name  = "dns.enabled"
    value = true
  }
}
