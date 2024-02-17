resource "aws_vpc" "main_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = var.vpc_name
  }
}

resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    Name = var.igw_name
  }
}

resource "aws_subnet" "public_subnet" {
  count                   = 3
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = var.public_subnet_cidr[count.index]
  map_public_ip_on_launch = true
  availability_zone       = var.availability_zones[count.index]
  tags = {
    Name = "${var.public_subnet_name}_${count.index}"
  }
}

resource "aws_eip" "nat_eip" {
  count = 3
}

resource "aws_nat_gateway" "main_nat_gw" {
  count         = 3
  allocation_id = aws_eip.nat_eip[count.index].id
  subnet_id     = aws_subnet.public_subnet[count.index].id
  tags = {
    Name = "${var.nat_gw_name}_${count.index}"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_igw.id
  }
  tags = {
    Name = var.public_route_table_name
  }
}

resource "aws_route_table_association" "public_rta" {
  count          = length(aws_subnet.public_subnet.*.id)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_subnet" "private_subnet" {
  count             = 3
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block              = var.private_subnet_cidr[count.index]
  availability_zone = var.availability_zones[count.index]
  tags = {
    Name = "${var.private_subnet_name}_${count.index}"
  }
}

resource "aws_route_table" "private_route_table" {
  count  = 3
  vpc_id = aws_vpc.main_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main_nat_gw[count.index].id
  }
  tags = {
    Name = "${var.private_route_table_name}_${count.index}"
  }
}

resource "aws_route_table_association" "private_rta" {
  count          = length(aws_subnet.private_subnet.*.id)
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_route_table[count.index].id
}
