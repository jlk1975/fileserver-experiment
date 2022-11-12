# fileserver-experiment

## Setup

- East Coast
  - Laptop/Workstation
    - Sign up for Linode account at linode.com
    - Obtain a personal access token for Linode’s v4 API to use with Terraform
    - Install Terraform (Laptop)
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
    -Prometheus Stuff
      - Plain ol Prometheus: 
        - https://prometheus.io/docs/prometheus/latest/getting_started/
        - ```wget https://github.com/prometheus/prometheus/releases/download/v2.40.1/prometheus-2.40.1.linux-amd64.tar.gz```
        - ```tar xvfz prometheus-*.tar.gz```
        - ```cd prometheus-*```
        - Prometheus collects metrics from targets by scraping metrics HTTP endpoints. Since Prometheus exposes data in the same manner about itself, it can also scrape and monitor its own health.
        - ```cp ./prometheus/prometheus.yaml ~/directory_you_untarred_prometheus_binary_into```
        - To start Prometheus with your newly created configuration file, change to the directory containing the Prometheus binary and run:
        - ```# Start Prometheus.```
        - ```# By default, Prometheus stores its database in ./data (flag --storage.tsdb.path).```
        - ```cd ~/directory_you_untarred_prometheus_binary_into```
        - ```./prometheus --config.file=prometheus.yml```
        - Point your web browser to http://localhost:9090/
        - Prometheus should be running now!
        - Go to http://localhost:9090/graph
        - Query Examples:
        - prometheus_target_interval_length_seconds
        - prometheus_target_interval_length_seconds{quantile="0.99"}
        - To count the number of returned time series, you could write:
        - count(prometheus_target_interval_length_seconds)
        - To graph expressions, navigate to http://localhost:9090/graph and use the "Graph" tab.
        - For example, enter the following expression to graph the per-second rate of chunks being created in the self-scraped Prometheus:
        - rate(prometheus_tsdb_head_chunks_created_total[1m])
        - More things to do with Prometheus can be found here:
          - https://prometheus.io/docs/prometheus/latest/getting_started/
        - MONITORING LINUX HOST METRICS WITH THE NODE EXPORTER (how to tie into grafana?)
          - https://prometheus.io/docs/guides/node-exporter/
          - Start up a Node Exporter on localhost
          - Start up a Prometheus instance on localhost that's configured to scrape metrics from the running Node Exporter
          - The Prometheus Node Exporter is a single static binary that you can install via tarball. Once you've downloaded it from the Prometheus downloads page extract it, and run it:
          - ```wget https://github.com/prometheus/node_exporter/releases/download/v1.4.0/node_exporter-1.4.0.linux-amd64.tar.gz```
          - ```tar xvf node_exporter-1.4.0.linux-amd64.tar.gz```
          - ```cd node_exporter-1.4.0.linux-amd64```
          - ```./node_exporter```
          - ```curl http://localhost:9100/metrics```
          - You should see output like this:
            - HELP go_gc_duration_seconds A summary of the GC invocation durations.
            - TYPE go_gc_duration_seconds summary
            - go_gc_duration_seconds{quantile="0"} 3.8996e-05
            - go_gc_duration_seconds{quantile="0.25"} 4.5926e-05
            - go_gc_duration_seconds{quantile="0.5"} 5.846e-05
            - etc.
            - Success! The Node Exporter is now exposing metrics that Prometheus can scrape, including a wide variety - - of system metrics further down in the output (prefixed with node_). 
            - To view those metrics (along with help and type information):
            - ```curl http://localhost:9100/metrics | grep "node_"```
            - https://prometheus.io/docs/guides/node-exporter/
            - Configuring your Prometheus instances
            - Your locally running Prometheus instance needs to be properly configured in order to access Node Exporter metrics. The following prometheus.yml example configuration file will tell the Prometheus instance to scrape, and how frequently, from the Node Exporter via localhost:9100:
            ```global:
            scrape_interval: 15s

            scrape_configs:
            - job_name: node
            static_configs:
            - targets: ['localhost:9100']```
            - Update prometheus.yaml file with above snippet and restart prometheus
            - ```./prometheus --config.file=prometheus.yaml```
            - Exploring Node Exporter metrics through the Prometheus expression browser
            Now that Prometheus is scraping metrics from a running Node Exporter instance, you can explore those metrics using the Prometheus UI (aka the expression browser). Navigate to localhost:9090/graph in your browser and use the main expression bar at the top of the page to enter expressions. 
            - Explore some of the node stats that prometheus has scraped from your node_exporter:
            - http://localhost:9090/graph?g0.range_input=1h&g0.expr=rate(node_cpu_seconds_total%7Bmode%3D%22system%22%7D%5B1m%5D)&g0.tab=1
            - http://localhost:9090/graph?g0.range_input=1h&g0.expr=node_filesystem_avail_bytes&g0.tab=1
            - http://localhost:9090/graph?g0.range_input=1h&g0.expr=rate(node_network_receive_bytes_total%5B1m%5D)&g0.tab=1
            - Explore promql:
            - https://prometheus.io/docs/prometheus/latest/querying/examples/
     - Now let's add Grafana to the mix:
       - https://grafana.com/docs/grafana/latest/getting-started/get-started-grafana-prometheus/
       - So the prometheus node_exporter goes on all nodes you want to monitor.
       - But you can install and run Prometheus on 1 machine of your choice.
       - Install Prometheus node_exporter
Prometheus node_exporter is a widely used tool that exposes system metrics. Install node_exporter on all hosts you want to monitor.
    - 

        

      - Prometheus node_exporter: 
        - https://prometheus.io/download/#node_exporter
      - Prometheus node_exporter installed using Ansible:
        - https://github.com/cloudalchemy/ansible-node-exporter
      - Prometheus Alert Manager
        - https://prometheus.io/download/#alertmanager 
    -Install Ansible (Laptop)
      - next steps, install the linode cli, then
      - login to your new file server instance and get a golang file server
      - running manually , just prove out that you can upload/download files over HTTP
      - from/to your laptop using curl. 
      - use this great article: https://medium.com/rungo/beginners-guide-to-serving-files-using-http-servers-in-go-4e542e628eac
      - after that, provision a client server 
      - and do the same thing. 
      - tbd
    - Splunk Stuff?


    - Terraform notes
      - To get images:
        - ```curl https://api.linode.com/v4/images```
        - Plan and Apply
        - ```terraform plan -var-file="secret.tfvars"```
        - ```terraform apply -var-file="secret.tfvars"```
    

  - Linode Servers
    - Control Server 
      - Let's not install Terraform here, just use it on laptop/workstation for now.
      - Let's not install Ansible here, just use it on laptop/workstation for now.
      - Git
      - Prometheus
      - Grafana 
        - Use these steps to manually install Grafana next:
        - GET EVERYTHING WORKING MANUALLY FIRST, THEN AUTOMATE INSTALLS/CONFIGS/DEPLOYMENTS..
          - https://grafana.com/docs/grafana/latest/setup-grafana/installation/debian/
          - ```sudo apt-get install -y apt-transport-https```
          - ```sudo apt-get install -y software-properties-common wget```
          - ```sudo wget -q -O /usr/share/keyrings/grafana.key https://apt.grafana.com/gpg.key```
          - ```echo "deb [signed-by=/usr/share/keyrings/grafana.key] https://apt.grafana.com stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list```
          - ```sudo apt-get update```
          - ```sudo apt-get install grafana-enterprise```
          - ```sudo systemctl daemon-reload```
          - ```sudo systemctl start grafana-server```
          - ```sudo systemctl status grafana-server```
          - Configure the Grafana server to start at boot:
          - ```sudo systemctl enable grafana-server.service```
          - https://grafana.com/docs/grafana/latest/getting-started/build-first-dashboard/
          - Next GO THROUGH THIS DOC:
          - https://grafana.com/docs/grafana/latest/datasources/add-a-data-source/

          - Then, install Ansible on your laptop and write some Ansible to install and configure Grafana on your linode Control instance. Maybe save docker for your golang fileserver
          app since it's going to need to be deployed to more than one fileserver, and since
          you are likely to update it's code (and you are not likely to update code for Grafana).
      - JMeter?  
      - Siege?
    - File Server (Origin)
      - File system
      - Golang file server code
        - Might want to also do this , it's a lot but really explains how to use LKE
        - https://www.linode.com/docs/guides/lke-continuous-deployment-series/
      - a Prometheus "node_exporter" needs to be here.
    - CDN Server 1
      - VarnishCDN Opensource Software
      - a Prometheus "node_exporter" needs to be here.
    - Client Server 1 (This is an end client that needs to download files)
      - Can be configured to download from origin file server, or CDN
      - a Prometheus "node_exporter" needs to be here.
      - wget?
      - curl?
      - Apache JMeter?
      - Siege?
      - Prometheus to gather file usage stats
- West Coast
  - Client Server 2 (This is an end client that needs to download files)
    - Can be configured to download from origin file server, or CDN.
    - a Prometheus "node_exporter" needs to be here.
    - wget?
    - curl?
    - Apache JMeter?
    - Siege?
    - Prometheus to gather file usage stats