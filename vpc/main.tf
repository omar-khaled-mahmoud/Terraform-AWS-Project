resource "aws_vpc" "environment" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

  tags = {
    Name = var.environment
  }
}

resource "aws_internet_gateway" "environment" {
  vpc_id = aws_vpc.environment.id

  tags = {
    Name = "${var.environment}-igw"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.environment.id

  tags = {
    Name = "${var.environment}-public"
  }
}

resource "aws_route_table" "private" {
  count  = length(var.private_subnets)
  vpc_id = aws_vpc.environment.id

  tags = {
    Name = "${var.environment}-private"
  }
}

resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.environment.id
}

resource "aws_route" "private_nat_gateway" {
  count                  = length(var.private_subnets)
  route_table_id         = aws_route_table.private[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.environment[count.index].id
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.environment.id
  cidr_block              = var.public_subnets[count.index]
  map_public_ip_on_launch = var.map_public_ip_on_launch
  availability_zone       = var.availability_zones[count.index]
  
  tags = {
    Name = "${var.environment}-public-${count.index}"
  }

  count = length(var.public_subnets)
}

resource "aws_subnet" "private" {
  vpc_id                  = aws_vpc.environment.id
  cidr_block              = var.private_subnets[count.index]
  map_public_ip_on_launch = "false"
  availability_zone       = var.availability_zones[count.index]

  tags = {
    Name = "${var.environment}-private-${count.index}"
  }

  count = length(var.private_subnets)
}

resource "aws_route_table_association" "private" {
  count          = length(var.private_subnets)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_eip" "environment" {
  count = length(var.public_subnets)

  vpc = true
}

resource "aws_nat_gateway" "environment" {
  count = length(var.public_subnets)

  allocation_id = aws_eip.environment[count.index].id
  subnet_id     = aws_subnet.public[count.index].id
}

