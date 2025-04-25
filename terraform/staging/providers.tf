#--------------
# providers.tf
#--------------

# Terraform Provider config (Compulsory)
# Ref: https://developer.hashicorp.com/terraform/language/terraform
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

# Digital Ocean Provider config
# Ref: https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs
provider "digitalocean" {
  token = var.do_token
}