## Create an instance template for HTTP
resource "google_compute_health_check" "http_health_check" {
  name               = "http-health-check"
  check_interval_sec = 5
  timeout_sec        = 5
  http_health_check {
    port = 80
  }
}

## Create a backend service for HTTP
resource "google_compute_backend_service" "http_backend_service" {
  name        = "http-backend-service"
  port_name   = "http"
  protocol    = "HTTP"
  timeout_sec = 10
  health_checks = [
    google_compute_health_check.http_health_check.self_link
  ]
  backend {
    group = google_compute_instance_group.http_instance_group.self_link
  }
}

## Create a URL map to route requests to the backend
resource "google_compute_url_map" "http_url_map" {
  name            = "http-url-map"
  default_service = google_compute_backend_service.http_backend_service.self_link
}

## Create a target HTTP proxy to route requests to the URL map
resource "google_compute_target_http_proxy" "http_http_proxy" {
  name    = "http-http-proxy"
  url_map = google_compute_url_map.http_url_map.self_link
}

## Create a global IP address for the HTTP load balancer
resource "google_compute_global_address" "http_global_ip" {
  name = "http-global-ip"
}

## Create a global forwarding rule for HTTP
resource "google_compute_global_forwarding_rule" "http_http_forwarding_rule" {
  name       = "http-http-forwarding-rule"
  target     = google_compute_target_http_proxy.http_http_proxy.self_link
  port_range = "80"
  ip_address = google_compute_global_address.http_global_ip.address
}

## Output the IP address of the HTTP load balancer
output "load_balancer_ip" {
  description = "The IP address of the HTTP load balancer"
  value       = google_compute_global_address.http_global_ip.address
}
