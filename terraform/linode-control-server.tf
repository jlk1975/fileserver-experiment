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

resource "linode_instance" "terraform-control" {
        image = "linode/ubuntu18.04"
        label = "Terraform-Control"
        group = "Terraform"
        region = "us-east"
        type = "g6-nanode-1"
        authorized_keys = [ "YOUR_PUBLIC_SSH_KEY" ]
        root_pass = var.root_pass
}