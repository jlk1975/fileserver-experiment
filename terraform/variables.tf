variable "linode_token" {
    description = "token for linode"
    type = string
    sensitive =true
}
variable "root_pass" {
    description = "root password"
    type = string
    sensitive =true
}
variable "authorized_keys" {
    description = "authorized_keys for ssh"
    type = string
    sensitive =true
}