locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("environment.hcl"))
}

terraform {
  source = "gcp-networking"
}

include {
  path = find_in_parent_folders()
}

inputs = {

  prefix = local.environment_id
  name = "sample-nw"

  mtu = 1500

  subnetworks = {
    public-infress = {
      
      cidr = "10.100.0.0/22",
      region = "us-central1",

    }
  }

  service_networking_regions = [
    "us-central1",
  ]

}