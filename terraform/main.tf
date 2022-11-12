terraform {
  required_providers {
    linode = {
      source = "linode/linode"
      version = "1.29.3"
    }
  }
}

provider "linode" {
  token = var.linode_token
}

resource "linode_firewall" "my_firewall" {
  label = "my_firewall"


 inbound {
    label    = "allow-ssh"
    action   = "ACCEPT"
    protocol = "TCP"
    ports    = "22"
    ipv4     = ["0.0.0.0/0"]
    ipv6     = ["::/0"]
  }

  inbound {
    label    = "allow-http"
    action   = "ACCEPT"
    protocol = "TCP"
    ports    = "3000"
    ipv4     = ["0.0.0.0/0"]
    ipv6     = ["::/0"]
  }

  inbound {
    label    = "allow-https"
    action   = "ACCEPT"
    protocol = "TCP"
    ports    = "443"
    ipv4     = ["0.0.0.0/0"]
    ipv6     = ["::/0"]
  }

  inbound_policy = "DROP"

/*
  outbound {
    label    = "reject-http"
    action   = "DROP"
    protocol = "TCP"
    ports    = "80"
    ipv4     = ["0.0.0.0/0"]
    ipv6     = ["::/0"]
  }

  outbound {
    label    = "reject-https"
    action   = "DROP"
    protocol = "TCP"
    ports    = "443"
    ipv4     = ["0.0.0.0/0"]
    ipv6     = ["::/0"]
  }
*/
  outbound_policy = "ACCEPT"

  linodes = [linode_instance.terraform-control.id]
}

resource "linode_instance" "terraform-control" {
        image = "linode/debian10"
        label = "Terraform-Control"
        group = "Terraform"
        region = "us-east"
        type = "g6-nanode-1"
        authorized_keys = [var.authorized_keys]
        root_pass = var.root_pass
}
