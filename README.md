# fileserver-experiment

## Setup

- East Coast
  - Laptop/Workstation
    - Sign up for Linode account at linode.com
    - Obtain a personal access token for Linode’s v4 API to use with Terraform
    - Install Terraform
      - ```mkdir ~terraform```
      - ```cd ~terraform```
      - ```wget https://releases.hashicorp.com/terraform/1.3.4/terraform_1.3.4_linux_amd64.zip```
      - ```wget https://releases.hashicorp.com/terraform/1.3.4/terraform_1.3.4_SHA256SUMS```
      - ```wget https://releases.hashicorp.com/terraform/1.3.4/terraform_1.3.4_SHA256SUMS.sig```
      - Download the GPG public key, the file you want to verify, and its corresponding signature file. 
      - Name the key hashicorp.asc. 
      - Navigate to the directory where you saved hashicorp.asc and run the following command:
        - ```gpg --import hashicorp.asc```
      - Verify the key against the fingerprint for the key:
        - ```gpg --fingerprint C874011F0AB405110D02105534365D9472D7468F```
      - Make sure you don't see an error like this:
        - ```gpg: error reading key: No public key```
      - Verify the signature:
        - ```gpg --verify terraform_1.3.4_SHA256SUMS.sig terraform_1.3.4_SHA256SUMS```
      - You want to see "gpg: Good signature from "HashiCorp Security (hashicorp.com/security) <security@hashicorp.com>" [unknown]"
      - Warning such as "gpg: WARNING: This key is not certified with a trusted signature!" can probably be ignored. 
    - Verify the .zip archive’s checksum:
      - ```sha256sum -c terraform*SHA256SUMS 2>&1 | grep OK```
    - You want to see output that looks like this: "sha256sum -c terraform*SHA256SUMS 2>&1 | grep OK"
    - Configure Terraform
      - ```unzip terraform_*_linux_amd64.zip```
      - ```echo 'export PATH="$PATH:$HOME/terraform"' >> ~/.profile```
      - ```source ~/.profile```
      - Verify terraform can run by running:
      - ```terraform```
      - Create a .gitignore file with terraform stuff to ignore (example included in this git repo.)
      - Create a secret.tfvars file and add your Linode API key into it
      - Create a linode-control-server.tf file (or use the one in this github repo in the terraform directory.)
      - cd ~/terraform or cd terraform (into your github checkout of this repo if you prefer)
      - ```terraform init```
      - ```terraform plan -var-file="secret.tfvars"```
      - ```terraform apply -var-file="secret.tfvars"```
      - 




    

  - Linode Servers
    - Control Server 
      - Git
      - Terraform
      - Ansible
      - Grafana Dashboard
      - JMeter?  
      - Siege?
    - File Server
      - File system
      - Golang file server code
    - CDN Server 1
      - VarnishCDN Opensource Software
    - Client Server 1 (This is an end client that needs to download files)
      - Can be configured to download from origin file server, or CDN
      - wget?
      - curl?
      - Apache JMeter?
      - Siege?
      - Prometheus to gather file usage stats
- West Coast
  - Client Server 2 (This is an end client that needs to download files)
    - Can be configured to download from origin file server, or CDN.
    - wget?
    - curl?
    - Apache JMeter?
    - Siege?
    - Prometheus to gather file usage stats