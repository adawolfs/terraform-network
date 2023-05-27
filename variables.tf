variable "project_id" {
  description = "The GCP Projec ID"
}

variable "ssh_posix_user" {
  description = "The POSIX user to connect to the instance with"
}

variable "prevent_destroy_static_ip" {
  description = "Prevent the static IP from being destroyed"
  type        = bool
  default     = false
}

variable "region" {
  description = "The region to deploy resources to"
  default     = "us-west2"
}

variable "zone" {
  description = "The zone to deploy resources to"
  default     = "us-west2-a"
}

variable "credentials_file" {
  description = "The path to the credentials file"
  default     = "./credentials.json"
}

variable "ssh_key_path" {
  description = "The path to the SSH key"
  default     = "./ssh-key"

}


