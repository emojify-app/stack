/*
data "digitalocean_image" "payment" {
  name = "emojify-payment"
}

resource "tls_private_key" "payment" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}

resource "digitalocean_ssh_key" "payment" {
  name       = "Payment SSH Key"
  public_key = "${tls_private_key.payment.public_key_openssh}"
}

resource "digitalocean_droplet" "payment" {
  image    = "${data.digitalocean_image.payment.image}"
  name     = "payment-service"
  region   = "lon1"
  size     = "s-1vcpu-1gb"
  ssh_keys = ["${digitalocean_ssh_key.payment.id}"]

  // add the kubernetes config for consul autojoin
  provisioner "remote-exec" {
    connection {
      host        = "${self.ipv4_address}"
      type        = "ssh"
      user        = "root"
      private_key = "${tls_private_key.payment.private_key_pem}"
      agent       = false
    }

    inline = [
      "mkdir -p /home/ubuntu/.kube",
      "echo \"${digitalocean_kubernetes_cluster.foobar.kube_config.0.raw_config}\" > /home/ubuntu/.kube/config",
    ]
  }
}

resource "digitalocean_firewall" "connect" {
  name = "ssh-and-consul-connect"

  droplet_ids = ["${digitalocean_droplet.payment.id}"]

  inbound_rule = [
    {
      protocol         = "tcp"
      port_range       = "22"
      source_addresses = ["0.0.0.0/0"]
    },
    {
      protocol         = "tcp"
      port_range       = "8443"
      source_addresses = ["${digitalocean_kubernetes_cluster.foobar.cluster_subnet}"]
    },
  ]

  outbound_rule = [
    {
      protocol              = "tcp"
      port_range            = "1-65535"
      destination_addresses = ["0.0.0.0/0", "::/0"]
    },
    {
      protocol              = "udp"
      port_range            = "1-65535"
      destination_addresses = ["0.0.0.0/0", "::/0"]
    },
    {
      protocol              = "icmp"
      destination_addresses = ["0.0.0.0/0", "::/0"]
    },
  ]
}
*/

