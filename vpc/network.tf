resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = merge(
    var.tags,
    {
      Name = "${var.name}"
    }
  )
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id
  tags = merge(
    var.tags,
    {
      Name = "${var.name}-public"
    }
  )
}

resource "aws_route_table_association" "public" {
  count          = length(var.cidr_public)
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public.id
}
