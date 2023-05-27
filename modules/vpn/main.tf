# Create VPN Static IP
resource "google_compute_address" "vpn_static_ip" {
  name = "vpn-static-ip"
}

# Create VPN Disk
resource "google_compute_disk" "vpn_disk" {
  name     = "vpn-disk"
  type     = "pd-standard"
  zone     = var.instance_zone
  size     = 10
  snapshot = "projects/terraform-network-01/global/snapshots/pfsense-260-image"

}

# Setup VPN Server
resource "google_compute_instance" "vpn_server" {
  name         = var.instance_name
  machine_type = var.instance_type
  zone         = var.instance_zone

  metadata = {
    # ssh-keys = "${var.ssh_user}:${file(var.ssh_pub_key_path)}"
    enable-oslogin = var.enable_oslogin
    # startup-script = file("./modules/vpn/script.sh")
  }

  tags = var.server_tags

  boot_disk {
    source = google_compute_disk.vpn_disk.self_link
  }


  # provisioner "remote-exec" {
  #   inline = [
  #     "echo  VPN_SERVER_IP=${self.network_interface[0].access_config[0].nat_ip} | sudo tee -a /etc/profile.d/terraform-setup.sh",
  #     "echo  ${self.network_interface[0].access_config[0].nat_ip} | sudo tee -a /tmp/vpn-server-ip",
  #   ]
  # }

  connection {
    type        = "ssh"
    host        = self.network_interface[0].access_config[0].nat_ip
    user        = var.ssh_posix_user
    private_key = file(var.ssh_key_path)
  }

  network_interface {
    subnetwork = var.vpc_vpn_subnet.self_link

  }

  network_interface {
    subnetwork = var.vpc_dmz_subnet.self_link
    access_config {
      nat_ip = google_compute_address.vpn_static_ip.address
    }
  }
  network_interface {
    subnetwork = var.vpc_intra_subnet.self_link
  }
}

# Create Firewall Rules
## Allow UDP 500 and 4500 for IPSec
resource "google_compute_firewall" "vpc_firewall_ipsec" {
  name    = "vpn-firewall-ipsec"
  network = var.vpc_vpn_network.self_link
  allow {
    protocol = "udp"
    ports    = ["500", "4500"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = var.server_tags
}

## Allow TCP 22 for SSH
resource "google_compute_firewall" "vpn_firewall_ssh" {
  name    = "vpn-firewall-ssh"
  network = var.vpc_vpn_network.self_link
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = var.server_tags
}

## Allow TCP 80 and 443 for HTTP
resource "google_compute_firewall" "vpn_firewall_http" {
  name    = "vpn-firewall-http"
  network = var.vpc_vpn_network.self_link
  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = var.server_tags
}

## Allow TCP 80 and 443 for HTTP
resource "google_compute_firewall" "vpn_dmz_firewall_http" {
  name    = "vpn-dmz-firewall-http"
  network = var.vpc_dmz_network.self_link
  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = var.server_tags
}
