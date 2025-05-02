#--------------
# variables.tf
#--------------

variable "name" {
  description = "Firewall name"
  type        = string
}

variable "inbound_rules" {
  description = "List of inbound rule objects"
  type = list(object({
    protocol         = string
    port_range       = string
    source_addresses = list(string)
  }))
}

variable "outbound_rules" {
  description = "List of outbound rule objects"
  type = list(object({
    protocol              = string
    port_range            = string
    destination_addresses = list(string)
  }))
}