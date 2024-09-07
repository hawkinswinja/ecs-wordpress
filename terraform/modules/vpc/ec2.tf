# Public EC2 instance for debugging
data "aws_ami" "ecs" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "debug" {
  count           = var.debug ? 1 : 0
  ami             = data.aws_ami.ecs.id
  instance_type   = "t2.micro"
  key_name        = var.ssh_key_name
  subnet_id       = aws_subnet.ecs-public-subnet[0].id
  security_groups = [aws_security_group.public_sg.id]
  tags = {
    Name = "Dev"
  }

}