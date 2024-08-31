# VPC, Internet Gateway, NAT Gateway, Public and Private Subnets

resource "aws_vpc" "ecs-vpc" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = true

  tags = {
    Name    = var.vpc_name
    Project = "${var.vpc_name}-vpc"
  }
}

resource "aws_internet_gateway" "ecs-igw" {
  vpc_id = aws_vpc.ecs-vpc.id
  tags = {
    Name = "${var.vpc_name}-igw"
  }
}

resource "aws_eip" "nat" {
  domain     = "vpc"
  depends_on = [aws_internet_gateway.ecs-igw]

  tags = {
    Name = "${var.vpc_name}-nat-eip"
  }
}

resource "aws_nat_gateway" "ecs-ngw" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.ecs-public-subnet[0].id
  tags = {
    Name = "${var.vpc_name}-ngw"
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "ecs-public-subnet" {
  count = length(var.public_subnet_cidr)

  vpc_id            = aws_vpc.ecs-vpc.id
  cidr_block        = var.public_subnet_cidr[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]


  tags = {
    Name = "${var.vpc_name}-public-subnet-${count.index}"
  }
}

resource "aws_subnet" "ecs-private-subnet" {
  count = length(var.private_subnet_cidr)

  vpc_id            = aws_vpc.ecs-vpc.id
  cidr_block        = var.private_subnet_cidr[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]


  tags = {
    Name = "${var.vpc_name}-private-subnet-${count.index}"
  }
}