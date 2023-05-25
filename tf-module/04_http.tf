# Create Server Tags
variable "http_server_tags" {
  type    = list(string)
  default = ["http-server"]
}

# Setup HTTP Server
resource "google_compute_instance" "http_server" {
  name         = "http-server"
  machine_type = "e2-medium"
  zone         = "us-west1-c"

  metadata = {
    # ssh-keys = "${var.ssh_user}:${file(var.ssh_pub_key_path)}"
    enable-oslogin = "TRUE"
    startup-script = file("../scripts/http.sh")
  }

  tags = var.http_server_tags

  boot_disk {
    initialize_params {
      image = "centos-stream-9-v20230509"
    }
  }

  connection {
    type        = "ssh"
    host        = self.network_interface[0].network_ip
    user        = var.ssh_posix_user
    private_key = file(var.ssh_key_path)
  }

  network_interface {
    network    = google_compute_network.vpc_network.self_link
    subnetwork = google_compute_subnetwork.vpc_subnet.self_link
  }
}

## Allow HTTP Services
resource "google_compute_firewall" "http_firewall_tcp" {
  name    = "http-firewall-tcp"
  network = google_compute_network.vpc_network.self_link
  allow {
    protocol = "tcp"
    ports    = ["22", "80", "8008"]
  }
  source_ranges = [google_compute_subnetwork.vpc_subnet.ip_cidr_range]
  target_tags   = var.http_server_tags
}

## Allow Health Checks traffic
resource "google_compute_firewall" "http_firewall_health_check" {
  name    = "http-firewall-health-check"
  network = google_compute_network.vpc_network.self_link
  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
  source_ranges = ["130.211.0.0/22", "35.191.0.0/16"]
  target_tags   = var.http_server_tags
}

