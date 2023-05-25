variable "project_id" {

}

variable "prevent_destroy_static_ip" {
  description = "Prevent the static IP from being destroyed"
  type        = bool
  default     = false
}

variable "region" {
  description = "The region to deploy resources to"
  default     = "us-west1"
}

variable "zone" {
  description = "The zone to deploy resources to"
  default     = "us-west1-c"
}

variable "credentials_file" {
  description = "The path to the credentials file"
  default     = "../credentials.json"
}

variable "ssh_key_path" {
  description = "The path to the SSH key"
  default     = "./ssh-key"

}

variable "ssh_posix_user" {
  description = "The POSIX user to connect to the instance with"
  default     = "sa_111391862998039256557"
}

provider "google" {
  credentials = file("${var.credentials_file}")
  project     = var.project_id
  region      = var.region
  zone        = var.zone
}
