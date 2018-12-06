resource "digitalocean_kubernetes_cluster" "foobar" {
  name    = "consul-connect-example"
  region  = "lon1"
  version = "1.12.1-do.2"
  tags    = ["foo", "bar"]

  node_pool {
    name       = "default"
    size       = "s-1vcpu-2gb"
    node_count = 3
    tags       = ["one", "two"] // Tags from cluster are automatically added to node pools
  }
}

provider "kubernetes" {
  host = "${digitalocean_kubernetes_cluster.foobar.kube_config.0.host}"

  client_certificate     = "${base64decode(digitalocean_kubernetes_cluster.foobar.kube_config.0.client_certificate)}"
  client_key             = "${base64decode(digitalocean_kubernetes_cluster.foobar.kube_config.0.client_key)}"
  cluster_ca_certificate = "${base64decode(digitalocean_kubernetes_cluster.foobar.kube_config.0.cluster_ca_certificate)}"
}

// set up the service account and role for tiller
resource "kubernetes_service_account" "tiller" {
  metadata {
    name      = "tiller"
    namespace = "kube-system"
  }

  automount_service_account_token = true
}

resource "kubernetes_cluster_role_binding" "tiller" {
  metadata {
    name = "tiller-clusterrolebinding"
  }

  role_ref {
    kind      = "ClusterRole"
    name      = "cluster-admin"
    api_group = "rbac.authorization.k8s.io"
  }

  subject {
    kind      = "ServiceAccount"
    name      = "${kubernetes_service_account.tiller.metadata.0.name}"
    namespace = "kube-system"
    api_group = ""
  }
}
