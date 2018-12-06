resource "helm_release" "dashboard" {
  //  depends_on = ["kubernetes_service_account.tiller", "kubernetes_cluster_role_binding.tiller", "kubernetes_deployment.tiller-deploy"]
  depends_on = ["kubernetes_service_account.tiller", "kubernetes_cluster_role_binding.tiller"]

  name      = "kubernetes-dashboard"
  chart     = "${path.module}/helm_charts/kubernetes-dashboard"
  timeout   = 1000
  namespace = "kube-system"

  set {
    name  = "version"
    value = "0.1.0"
  }
}
