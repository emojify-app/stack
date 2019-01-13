terraform {
  backend "s3" {
    skip_requesting_account_id  = true
    skip_credentials_validation = true
    skip_get_ec2_platforms      = true
    skip_metadata_api_check     = true
    endpoint                    = "https://tfremotestate.ams3.digitaloceanspaces.com"
    region                      = "us-east-1"                                         # Requires any valid AWS region
    bucket                      = ""                                                  # Space name
    key                         = "emojify/terraform.tfstate"
  }
}

provider "helm" {
  kubernetes {
    host = "${digitalocean_kubernetes_cluster.emojify.endpoint}"

    client_certificate     = "${base64decode(digitalocean_kubernetes_cluster.emojify.kube_config.0.client_certificate)}"
    client_key             = "${base64decode(digitalocean_kubernetes_cluster.emojify.kube_config.0.client_key)}"
    cluster_ca_certificate = "${base64decode(digitalocean_kubernetes_cluster.emojify.kube_config.0.cluster_ca_certificate)}"
  }

  service_account = "${kubernetes_service_account.tiller.metadata.0.name}"
  namespace       = "${kubernetes_service_account.tiller.metadata.0.namespace}"
  tiller_image    = "gcr.io/kubernetes-helm/tiller:v2.12.0"
}

provider "kubernetes" {
  host = "${digitalocean_kubernetes_cluster.emojify.endpoint}"

  client_certificate     = "${base64decode(digitalocean_kubernetes_cluster.emojify.kube_config.0.client_certificate)}"
  client_key             = "${base64decode(digitalocean_kubernetes_cluster.emojify.kube_config.0.client_key)}"
  cluster_ca_certificate = "${base64decode(digitalocean_kubernetes_cluster.emojify.kube_config.0.cluster_ca_certificate)}"
}
