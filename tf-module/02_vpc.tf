# Create VPN Static IP
resource "google_compute_address" "vpn_static_ip" {
  name = "vpn-static-ip"
}



# Create a VPC Network and Subnet
resource "google_compute_network" "vpc_network" {
  name                    = "private-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "vpc_subnet" {
  name          = "private-subnet"
  ip_cidr_range = "10.0.1.0/24"
  network       = google_compute_network.vpc_network.self_link
}

# Required to allow vpc traffic go outside
resource "google_compute_router" "vpc_router" {
  name    = "vpc-router"
  network = google_compute_network.vpc_network.name
}

resource "google_compute_router_nat" "vpc_nat" {
  name   = "vpc-gateway"
  router = google_compute_router.vpc_router.name

  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}
