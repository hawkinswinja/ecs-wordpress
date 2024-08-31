# Security Group configuration

resource "aws_security_group" "public_sg" {
  name        = "public_sg"
  description = "Allow inbound traffic on port 443 and 22"

  vpc_id = aws_vpc.ecs-vpc.id

  ingress {
    description = "Allow inbound traffic from the internet on port 443"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow inbound traffic from the internet on port 22"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow outbound traffic to private subnets on port 80"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.private_subnet_cidr
  }

  egress {
    description = "Allow outbound traffic to private subnets on port 22"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.private_subnet_cidr
  }

  egress {
    description = "Allow outbound traffic to the internet on all ports"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "private_sg" {
  name        = "private_sg"
  description = "Allow inbound traffic from public_sg and efs_sg"

  vpc_id = aws_vpc.ecs-vpc.id

  ingress {
    description = "Allow ssh from public security group"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [aws_security_group.public_sg.id]
  }

  ingress {
    description = "Allow http from public security group"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [aws_security_group.public_sg.id]
  }

  egress {
    description = "Allow mysql traffic to rds security group"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = [aws_security_group.rds_sg.id]
  }

  egress {
    description = "Allow https for connecting to ecs agent"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow nfs traffic to efs security group"
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    security_groups = [aws_security_group.efs_sg.id]
  }
 
}

resource "aws_security_group" "rds_sg" {
  name        = "rds_sg"
  description = "Allow mysql traffic from private subnets"

  vpc_id = aws_vpc.ecs-vpc.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = var.private_subnet_cidr
  }
}

resource "aws_security_group" "efs_sg" {
  name        = "efs_sg"
  description = "Allow nfs from private subnet on port 2049"

  vpc_id = aws_vpc.ecs-vpc.id

  ingress {
    from_port       = 2049
    to_port         = 2049
    protocol        = "tcp"
    cidr_blocks = var.private_subnet_cidr
  }

}
