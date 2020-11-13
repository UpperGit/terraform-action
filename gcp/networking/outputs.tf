output "private_vpc_connection" {
	# See https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_database_instance#private-ip-instance
	description = "VPC private services peering connection (use as depends_on value)"
	value = google_service_networking_connection.private_vpc_connection
}

output "private_network_id" {
	description = "VPC ID"
	value = google_compute_network.private_network.id
}