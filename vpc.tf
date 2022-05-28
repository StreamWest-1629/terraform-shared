module "vpc_1" {
  name     = "${var.PROJECT_NAME}-1"
  source   = "./vpc"
  cidr_vpc = "10.0.0.0/16"
  cidr_public = [
    "10.0.0.0/20",
    "10.0.128.0/20"
  ]
  cidr_private = [
    "10.0.16.0/20",
    "10.0.144.0/20"
  ]
  tags = {
    ProjectName = var.PROJECT_NAME
  }
}

output "vpc_1_vpcid" {
  value     = module.vpc_1.vpcid
  sensitive = true
}

output "vpc_1_public_1_subnetid" {
  value     = module.vpc_1.public_subnet_id[0]
  sensitive = true
}

output "vpc_1_public_2_subnetid" {
  value     = module.vpc_1.public_subnet_id[1]
  sensitive = true
}

output "vpc_1_private_1_subnetid" {
  value     = module.vpc_1.private_subnet_id[0]
  sensitive = true
}

output "vpc_1_private_2_subnetid" {
  value     = module.vpc_1.private_subnet_id[1]
  sensitive = true
}
