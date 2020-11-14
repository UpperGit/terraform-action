locals {

  service_networking_regions = { for region in var.service_networking_regions : region => region }

}

############################
# VPC
############################

resource "google_compute_network" "private_network" {
  provider     = google
  name         = "${var.prefix}-${var.name}"
  mtu          = var.mtu
  routing_mode = "REGIONAL"


  auto_create_subnetworks         = false
  delete_default_routes_on_create = true

}

############################
# Subnets
############################

resource "google_compute_subnetwork" "subnets" {
  provider     = google
  for_each = var.subnetworks

  network = google_compute_network.private_network.id

  name = "${var.prefix}-${var.name}-${each.value["region"]}-${each.key}"

  ip_cidr_range = each.value["cidr"]
  region        = each.value["region"]

  private_ipv6_google_access = true
  private_ip_google_access   = true

}

############################
# Routing
############################

resource "google_compute_route" "vpc_route_default_internet_gw" {
  provider     = google
  name             = "${var.prefix}-${var.name}-default-internet-gateway"
  dest_range       = "0.0.0.0/0"
  network          = google_compute_network.private_network.name
  next_hop_gateway = "default-internet-gateway"
  priority         = 1000
}

############################
# VPC private services
############################

resource "google_compute_global_address" "private_ip_address" {
  provider = google-beta

  for_each = local.service_networking_regions

  name          = "${var.prefix}-${var.name}-${each.value}"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.private_network.id
}

resource "google_service_networking_connection" "private_vpc_connection" {
  provider = google-beta

  for_each = local.service_networking_regions

  network = google_compute_network.private_network.id
  service = "servicenetworking.googleapis.com"

  reserved_peering_ranges = [
    google_compute_global_address.private_ip_address[each.key].name,
  ]
}
