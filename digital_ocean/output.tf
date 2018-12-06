// k8s config
output "k8s_config" {
  value = "${digitalocean_kubernetes_cluster.foobar.kube_config.0.raw_config}"
}

/*
output "payment_host" {
  value = "${digitalocean_droplet.payment.ipv4_address}"
}

output "payment_key" {
  value = "${tls_private_key.payment.private_key_pem}"
}
*/

