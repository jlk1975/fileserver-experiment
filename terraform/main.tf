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
        image = "linode/debian10"
        label = "Terraform-Control"
        group = "Terraform"
        region = "us-east"
        type = "g6-nanode-1"
        authorized_keys = [var.authorized_keys]
        root_pass = var.root_pass
}
