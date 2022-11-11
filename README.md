# fileserver-experiment

## Setup

- East Coast
  - Laptop/Workstation
    - Sign up for Linode account at linode.com
    - Obtain a personal access token for Linode’s v4 API to use with Terraform
    - Install Terraform
    - ```mkdir ~terraform```
    - ```cd ~terraform```
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