# Routing table, subnet associations and ECR

resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.ecs-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ecs-igw.id
  }

  route {
    cidr_block = var.vpc_cidr
    gateway_id = "local"
  }

  tags = {
    key   = "Name"
    value = "${var.vpc_name}-public-rt"
  }
}

resource "aws_route_table" "private-route-table" {
  vpc_id = aws_vpc.ecs-vpc.id

  route {
    cidr_block = var.vpc_cidr
    gateway_id = "local"
  }

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ecs-ngw.id
  }

  tags = {
    key   = "Name"
    value = "${var.vpc_name}-private-rt"
  }
}

resource "aws_route_table_association" "private_subnet-association" {
  count          = length(var.private_subnet_cidr)
  subnet_id      = aws_subnet.ecs-private-subnet[count.index].id
  route_table_id = aws_route_table.private-route-table.id
}

resource "aws_route_table_association" "public_subnet-association" {
  count          = length(var.public_subnet_cidr)
  subnet_id      = aws_subnet.ecs-public-subnet[count.index].id
  route_table_id = aws_route_table.public-route-table.id
}