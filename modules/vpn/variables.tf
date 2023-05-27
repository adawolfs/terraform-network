variable "server_tags" {
  type    = list(string)
  default = ["vpn-server"]
}

variable "ssh_posix_user" {
  description = "The POSIX user to connect to the instance with"
}

variable "ssh_key_path" {
  description = "The path to the SSH key"
  default     = "./ssh-key"
}

variable "instance_image" {
  description = "The OS image to use"
  default     = "centos-stream-9-v20230509"
}

variable "instance_name" {
  description = "The name of the instance"
  default     = "vpn-server"
}

variable "instance_type" {
  description = "The type of the instance"
  default     = "e2-standard-4"
}

variable "instance_zone" {
  description = "The zone to deploy resources to"
  default     = "us-west2-a"
}

variable "firewall_rule_name" {
  description = "The name of the firewall rule"
  default     = "vpn-firewall-tcp"
}

variable "firewall_rule_ports" {
  description = "The ports of the firewall rule"
  type        = list(number)
  default     = [22, 80]
}

variable "firewall_rule_protocol" {
  description = "The protocol of the firewall rule"
  default     = "tcp"
}

variable "enable_oslogin" {
  description = "Enable OS Login"
  default     = "TRUE"
}

variable "vpc_vpn_network" {

}

variable "vpc_vpn_subnet" {

}

variable "vpc_dmz_network" {

}

variable "vpc_dmz_subnet" {

}

variable "vpc_intra_network" {

}

variable "vpc_intra_subnet" {

}
