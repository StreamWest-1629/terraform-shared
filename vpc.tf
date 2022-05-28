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
