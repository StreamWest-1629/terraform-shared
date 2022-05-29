
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
  availability_zone = element(var.az_names, count.index)
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
  availability_zone = element(var.az_names, count.index)
  tags = merge(
    var.tags,
    {
      Name = "${var.name}-private-${count.index + 1}"
    }
  )
}

output "vpcid" {
  value = aws_vpc.vpc.id
}

output "public_subnet_id" {
  value = aws_subnet.public.*.id
}

output "private_subnet_id" {
  value = aws_subnet.private.*.id
}
