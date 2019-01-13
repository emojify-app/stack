/*
output "server_ssh_private_key" {
  value = "${tls_private_key.server.private_key_pem}"
}
*/

output "postgres_fqdn" {
  value = "${element(concat(azurerm_postgresql_server.emojify_db.*.fqdn, list("")),0)}"
}

output "postgres_user" {
  value = "${element(concat(azurerm_postgresql_server.emojify_db.*.administrator_login, list("")),0)}"
}

output "postgres_password" {
  value = "${element(concat(azurerm_postgresql_server.emojify_db.*.administrator_login_password, list("")),0)}"
}

output "postgres_database" {
  value = "${element(concat(azurerm_postgresql_server.emojify_db.*.name, list("")),0)}"
}

output "redis_fqdn" {
  value = "${element(concat(azurerm_redis_cache.emojify_cache.*.hostname, list("")),0)}"
}

output "redis_port" {
  value = "${element(concat(azurerm_redis_cache.emojify_cache.*.port, list("")),0)}"
}

output "redis_key" {
  value = "${element(concat(azurerm_redis_cache.emojify_cache.*.primary_access_key, list("")),0)}"
}

output "application_fqdn" {
  value = "${data.terraform_remote_state.core.k8s_ingress_fqdn}"
}

output "payment_host" {
  value = "${data.azurerm_public_ip.payment.ip_address}"
}

output "payment_key" {
  value = "${tls_private_key.payment.private_key_pem}"
}
