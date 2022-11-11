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