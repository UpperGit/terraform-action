variable "prefix" {
  type        = string
  description = "Resources name prefix, you can use something like the environment slug or a unique commit hash"
}

variable "name" {
  type        = string
  description = "Unique network name, suggestion: use a slug like 'my_network'"
}

variable "mtu" {
  type        = number
  description = "VPC network mtu"
  default     = 1500
}

variable "service_networking_regions" {
	type = list(string)
	description = "Regions to enalbe Google private Service Networking"
	default = []
}

variable "subnetworks" {
  type        = map
  description = "Subnetworks definition mapped by unique name as key"
  default = {
    public-ingress = {

      cidr   = "10.100.0.0/22",
      region = "us-central1",

    },
  }
}
