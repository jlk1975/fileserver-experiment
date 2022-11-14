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

/*
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
    label    = "allow-http-prometheus"
    action   = "ACCEPT"
    protocol = "TCP"
    ports    = "9090"
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

  outbound_policy = "ACCEPT"

  linodes = [linode_instance.terraform-control.id]
}


resource "linode_stackscript" "terraform-control" {
  label = "foo"
  description = "Sets hostname"
  script = <<EOF
#!/bin/bash
hostnamectl set-hostname controller01
EOF
  images = ["linode/debian10"]
  rev_note = "initial version"
}

resource "linode_instance" "terraform-control" {
        image = "linode/debian10"
        label = "Terraform-Control"
        group = "Terraform"
        region = "us-east"
        type = "g6-nanode-1"
        authorized_keys = [var.authorized_keys]
        root_pass = var.root_pass

        stackscript_id = linode_stackscript.terraform-control.id
}
*/