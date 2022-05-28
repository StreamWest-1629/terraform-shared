
data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  az_names = data.aws_availability_zones.available.names
}

resource "aws_vpc" "vpc" {
  cidr_block = var.cidr_vpc
  tags = merge(
    var.tags,
    {
      Name = "${var.name}"
    }
  )
}

resource "aws_subnet" "public" {
  count             = length(var.cidr_public)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = element(var.cidr_public, count.index)
  availability_zone = element(local.az_names, count.index)
  tags = merge(
    var.tags,
    {
      Name = "${var.name}-public-${count.index + 1}"
    }
  )
}

resource "aws_subnet" "private" {
  count             = length(var.cidr_private)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = element(var.cidr_private, count.index)
  availability_zone = element(local.az_names, count.index)
  tags = merge(
    var.tags,
    {
      Name = "${var.name}-private-${count.index + 1}"
    }
  )
}
