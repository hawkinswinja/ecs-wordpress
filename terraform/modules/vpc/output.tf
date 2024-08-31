output "efs_sg" {
  value = aws_security_group.efs_sg.id
}
output "private_sg" {
  value = aws_security_group.private_sg.id
}
output "public_sg" {
  value = aws_security_group.public_sg.id
}

output "rds_sg" {
  value = aws_security_group.rds_sg.id
}

output "ecs-private-subnet" {
  value = aws_subnet.ecs-private-subnet[*].id
}

output "alb-subnet" {
  value = aws_subnet.ecs-public-subnet[*].id
}

output "vpc_id" {
  value = aws_vpc.ecs-vpc.id
}