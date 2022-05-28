variable "AWS_REGION" {}
variable "S3_BUCKETNAME" {}
variable "PROJECT_NAME" {}

terraform {
  backend "s3" {
    key = "terraform.tfstate"
  }
}

provider "aws" {
  region = var.AWS_REGION
}

resource "aws_s3_bucket" "main_bucket" {
  bucket = var.S3_BUCKETNAME
  tags = {
    ProjectName = var.PROJECT_NAME
  }
  lifecycle {
    prevent_destroy = true
  }
}
