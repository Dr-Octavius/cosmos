#----------------------
# Variable Definitions
#----------------------
variable "do_token" {
  description = "Digital Ocean API token"
  type        = string
  sensitive   = true
}

#-------------------------------
# Terraform Cloud Configuration
#-------------------------------
terraform {
  cloud {
    organization = "sefire"

    workspaces {
      name = "cosmos-sgp1-dev"
    }
  }

  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "2.50.0"
    }
  }
}

#------------------------
# Provider Configuration
#------------------------
provider "digitalocean" {
  token = var.do_token
}

#----------------------------
# Sefire Cluster Configuration
#----------------------------
resource "digitalocean_kubernetes_cluster" "sefire_sgp1_dev" {
  name    = "sefire-sgp1-dev"
  region  = "sgp1"
  version = "1.32.2-do.0"
  #--------------------------------------
  # To Be Automated via CICD pipeline
  # Include info not in name & dashboard
  # - K8s version
  # - Node Pool Name(s)
  # - Node Pool Owner(s)
  # - Cluster Owner(s)
  # - Compliance (If uniform)
  #--------------------------------------
  tags    = [
    "pdpa",
  ]

  #------------------------------------------
  # SCRIBE + Fluentd Node Pool Configuration
  #------------------------------------------
  node_pool {
    name       = "core-np"
    size       = "g-4vcpu-16gb"
    auto_scale = true
    min_nodes  = 1
    #-------------------------------------------
    # To increase pending Droplet Limit Request
    #-------------------------------------------
    max_nodes  = 5
    labels = {
      nodepool = "sefire-core-np"
    }
    #--------------------------------------
    # To Be Automated via CICD pipeline
    # Include info not in name & dashboard
    # - Image(s) Deployed
    # - Image Owner
    # - Node Pool Owner
    # - Compliance (If not uniform)
    #--------------------------------------
    tags    = [
      "general-purpose",
    ]
  }
}

#-------------------------------
# Sefire Firewall Configuration
#-------------------------------
resource "digitalocean_firewall" "sefire_sgp1_dev_firewall" {
  name = "sefire-sgp1-dev-firewall"

  #-----------------------------------
  # To Do Before Release:
  # - Restrict 6443 to trusted IPs
  # (i.e k8s connection with kubectl)
  #-----------------------------------
  inbound_rule {
    protocol         = "tcp"
    port_range       = "6443"
    source_addresses = ["0.0.0.0/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "50051"
    source_addresses = ["192.168.1.1/32", "192.168.10.4/32", "192.168.10.10/32"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "5061"
    source_addresses = ["192.168.1.1/32", "192.168.10.4/32", "192.168.10.10/32"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "9090"
    source_addresses = ["192.168.1.1/32", "192.168.10.4/32", "192.168.10.10/32"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["192.168.1.1/32", "192.168.10.4/32", "192.168.10.10/32"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "8080"
    source_addresses = ["10.104.0.0/20"]  # Allow traffic from all IPs within the VPC
  }

  outbound_rule {
    protocol              = "tcp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0"]
  }

  # Associate with the Kubernetes worker nodes
  #--------------------------------------
  # To Be Automated via CICD pipeline
  # Include info not in name & dashboard
  # - K8s version
  # - Node Pool Name(s)
  # - Node Pool Owner(s)
  # - Cluster Owner(s)
  # - Compliance (If uniform)
  #--------------------------------------
  # tags    = [
  #   "sefire-core-np",
  # ]

  depends_on = [
    digitalocean_kubernetes_cluster.sefire_sgp1_dev
  ]
}

#-------------------------------
# Kubernetes Credentials Output
#-------------------------------
output "kubeconfig" {
  value     = digitalocean_kubernetes_cluster.sefire_sgp1_dev.kube_config.0.raw_config
  sensitive = true
}
