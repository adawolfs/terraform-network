## VPN Network
output "vpn_network" {
  description = "The VPN network reference"
  value       = google_compute_network.vpc_vpn_network
}

## VPN Network
output "vpn_subnet" {
  description = "The VPN subnet reference"
  value       = google_compute_subnetwork.vpc_vpn_subnet
}

## DMZ Network
output "dmz_network" {
  description = "The DMZ network referece"
  value       = google_compute_network.vpc_dmz_network
}

## DMZ Subnet
output "dmz_subnet" {
  description = "The DMZ subnet reference"
  value       = google_compute_subnetwork.vpc_dmz_subnet
}

## Intra Network
output "intra_network" {
  description = "The Intra network reference"
  value       = google_compute_network.vpc_intra_network
}

## Intra Subnet
output "intra_subnet" {
  description = "The Intra subnet reference"
  value       = google_compute_subnetwork.vpc_intra_subnet
}
