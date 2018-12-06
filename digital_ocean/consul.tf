# Consul Helm chart
provider "helm" {
  kubernetes {
    host = "${digitalocean_kubernetes_cluster.foobar.kube_config.0.host}"

    client_certificate     = "${base64decode(digitalocean_kubernetes_cluster.foobar.kube_config.0.client_certificate)}"
    client_key             = "${base64decode(digitalocean_kubernetes_cluster.foobar.kube_config.0.client_key)}"
    cluster_ca_certificate = "${base64decode(digitalocean_kubernetes_cluster.foobar.kube_config.0.cluster_ca_certificate)}"
  }

  install_tiller  = true
  service_account = "tiller"
  tiller_image    = "gcr.io/kubernetes-helm/tiller:v2.11.0"
}

# Run consul on kubernetes
resource "helm_release" "consul" {
  // depends_on = ["kubernetes_service_account.tiller", "kubernetes_cluster_role_binding.tiller", "kubernetes_deployment.tiller-deploy"]
  depends_on = ["kubernetes_service_account.tiller", "kubernetes_cluster_role_binding.tiller"]

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
