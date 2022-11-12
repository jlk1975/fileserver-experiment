variable "linode_token" {
    description = "token for linode"
    type = string
    sensitive =true
}

variable "root_pass" {
    description = "root password"
    type = string
    sensitive =false
}