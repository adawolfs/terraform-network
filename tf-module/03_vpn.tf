# Create VPN Tags
variable "vpn_server_tags" {
  type    = list(string)
  default = ["vpn-server"]
}

# Setup VPN Server
resource "google_compute_instance" "vpn_server" {
  name         = "strongswan-server"
  machine_type = "e2-medium"
  zone         = "us-west1-c"

  metadata = {
    # ssh-keys = "${var.ssh_user}:${file(var.ssh_pub_key_path)}"
    enable-oslogin = "TRUE"
  }

  tags = var.vpn_server_tags

  boot_disk {
    initialize_params {
      image = "centos-stream-9-v20230509"
    }
  }

  provisioner "remote-exec" {
    inline = [
      "echo  VPN_SERVER_IP=${self.network_interface[0].access_config[0].nat_ip} | sudo tee -a /etc/profile.d/terraform-setup.sh",
      "echo  ${self.network_interface[0].access_config[0].nat_ip} | sudo tee -a /tmp/vpn-server-ip",
    ]
  }

  provisioner "remote-exec" {
    script = "../scripts/vpn.sh"
  }

  connection {
    type        = "ssh"
    host        = self.network_interface[0].access_config[0].nat_ip
    user        = var.ssh_posix_user
    private_key = file(var.ssh_key_path)
  }

  network_interface {
    network    = google_compute_network.vpc_network.self_link
    subnetwork = google_compute_subnetwork.vpc_subnet.self_link
    access_config {
      nat_ip = google_compute_address.vpn_static_ip.address
    }
  }

}

# Create Firewall Rules
## Allow UDP 500 and 4500 for IPSec
resource "google_compute_firewall" "vpc_firewall_ipsec" {
  name    = "vpn-firewall-ipsec"
  network = google_compute_network.vpc_network.self_link
  allow {
    protocol = "udp"
    ports    = ["500", "4500"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = var.vpn_server_tags
}

## Allow 
resource "google_compute_firewall" "vpn_firewall_ssh" {
  name    = "vpn-firewall-ssh"
  network = google_compute_network.vpc_network.self_link
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = var.vpn_server_tags
}
