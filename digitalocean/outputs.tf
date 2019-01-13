output "kube_config" {
  value = "${digitalocean_kubernetes_cluster.emojify.kube_config.0.raw_config}"
}
