# efs for task definition
resource "aws_efs_file_system" "fs" {
  creation_token = "${var.name}-efs"
  performance_mode = "generalPurpose"
  throughput_mode = "bursting"
  encrypted = true
#   lifecycle_policy {
#     transition_to_ia = "AFTER_30_DAYS"
#   }
  tags = {
    Name = "${var.name}-efs"
  }
}

# efs access point for task definition
resource "aws_efs_access_point" "test" {
  file_system_id = aws_efs_file_system.fs.id
  root_directory {
    path = "${var.efs_directory}"
    creation_info {
      owner_gid = 1000
      owner_uid = 1000
      permissions = "755"
    }
  }
}

#efs mount target for task definition
resource "aws_efs_mount_target" "efs_mount_target" {
  count = length(var.ecs_subnets)
  file_system_id = aws_efs_file_system.fs.id
  subnet_id = var.ecs_subnets[count.index]
  security_groups = var.efs_security_group_ids
}