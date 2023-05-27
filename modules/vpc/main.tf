# Create a VPC Network and Subnet
resource "google_compute_network" "vpc_vpn_network" {
  name                    = "vpn-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "vpc_vpn_subnet" {
  name          = "vpn-subnet"
  ip_cidr_range = "10.10.0.0/24"
  network       = google_compute_network.vpc_vpn_network.self_link
}

resource "google_compute_network" "vpc_dmz_network" {
  name                    = "dmz-network"
  auto_create_subnetworks = false
}

resource "google_compute_network" "vpc_intra_network" {
  name                    = "intra-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "vpc_dmz_subnet" {
  name          = "dmz-subnet"
  ip_cidr_range = "10.0.0.0/24"
  network       = google_compute_network.vpc_dmz_network.self_link
}

resource "google_compute_subnetwork" "vpc_intra_subnet" {
  name          = "intra-subnet"
  ip_cidr_range = "172.22.0.0/24"
  network       = google_compute_network.vpc_intra_network.self_link
}
