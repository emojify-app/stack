resource "digitalocean_kubernetes_cluster" "emojify" {
  name    = "emojify"
  region  = "ams3"
  version = "1.12.3-do.2"
  tags    = ["production"]

  node_pool {
    name       = "woker-pool"
    size       = "s-2vcpu-2gb"
    node_count = 3
  }
}

/*
resource "digitalocean_kubernetes_node_pool" "monitoring" {
  cluster_id = "${digitalocean_kubernetes_cluster.emojify.id}"

  name       = "monitoring-pool"
  size       = "s-2vcpu-4gb"
  node_count = 1
  tags       = ["monitoring"]
}
*/

// RBAC settings for HELM
resource "kubernetes_service_account" "tiller" {
  metadata {
    name      = "terraform-tiller"
    namespace = "kube-system"
  }

  automount_service_account_token = true
}

resource "kubernetes_cluster_role_binding" "tiller" {
  metadata {
    name = "terraform-tiller"
  }

  role_ref {
    kind      = "ClusterRole"
    name      = "cluster-admin"
    api_group = "rbac.authorization.k8s.io"
  }

  subject {
    kind = "ServiceAccount"
    name = "terraform-tiller"

    api_group = ""
    namespace = "kube-system"
  }
}

# Service Account for dashboard login
resource "kubernetes_service_account" "dashboard" {
  metadata {
    name      = "my-dashboard-sa"
    namespace = "default"
  }

  automount_service_account_token = true
}

resource "kubernetes_cluster_role_binding" "dashboard" {
  metadata {
    name = "kubernetes-dashboard"
  }

  role_ref {
    kind      = "ClusterRole"
    name      = "cluster-admin"
    api_group = "rbac.authorization.k8s.io"
  }

  subject {
    kind = "ServiceAccount"
    name = "my-dashboard-sa"

    api_group = ""
    namespace = "default"
  }
}

resource "helm_release" "dashboard" {
  depends_on = ["kubernetes_cluster_role_binding.tiller"]

  name      = "kubernetes-dashboard"
  chart     = "${path.module}/helm-charts/kubernetes-dashboard"
  timeout   = 300
  namespace = "kube-system"

  set {
    name  = "service.nameOverride"
    value = "kubernetes-dashboard"
  }
}
