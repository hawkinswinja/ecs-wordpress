# ECS TASK DEFINITION

resource "aws_ecs_task_definition" "task1" {
  family             = "${var.name}-task"
  task_role_arn      = aws_iam_role.ecs_task_role.arn
  execution_role_arn = aws_iam_role.ecs_exec_role.arn
  network_mode       = "awsvpc"
  memory             = 128
  container_definitions = jsonencode([{
    name      = "${var.name}-container",
    image     = "${aws_ecr_repository.repo.repository_url}:${var.image_tag}",
    essential = true,
    restart   = "always",
    portMappings = [{
      containerPort = var.container_port,
      protocol      = "tcp"
    }],

    mountPoints = [{
      sourceVolume  = "${var.name}-efs-volume",
      containerPath = var.container_path,
      readOnly      = false,
    }],

    secrets = [
      {
        name      = "WORDPRESS_DB_HOST"
        valueFrom = var.ssm_parameter["/wordpress/WORDPRESS_DB_HOST"].arn
      },
      {
        name      = "WORDPRESS_DB_NAME"
        valueFrom = var.ssm_parameter["/wordpress/WORDPRESS_DB_NAME"].arn
      },
      {
        name      = "WORDPRESS_DB_USER"
        valueFrom = var.ssm_parameter["/wordpress/WORDPRESS_DB_USER"].arn
      },
      {
        name      = "WORDPRESS_DB_PASSWORD"
        valueFrom = var.ssm_parameter["/wordpress/WORDPRESS_DB_PASSWORD"].arn
      },
    ]

    logConfiguration = {
      logDriver = "awslogs",
      options = {
        "awslogs-region"        = "${var.log_region}",
        "awslogs-group"         = aws_cloudwatch_log_group.ecs.name,
        "awslogs-stream-prefix" = "${var.name}-container-logs"
      }
    },
  }])

  volume {
    name = "${var.name}-efs-volume"
    efs_volume_configuration {
      file_system_id     = aws_efs_file_system.fs.id
      transit_encryption = "ENABLED"
      authorization_config {
        access_point_id = aws_efs_access_point.test.id
        iam             = "DISABLED"
      }
    }
  }
}

# ECS SERVICE
resource "aws_ecs_service" "default" {
  name                               = "${var.name}-service"
  cluster                            = aws_ecs_cluster.main.id
  task_definition                    = aws_ecs_task_definition.task1.arn
  scheduling_strategy                = "REPLICA"
  desired_count                      = 2
  launch_type                        = "EC2"
  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 150
  health_check_grace_period_seconds  = 60
  wait_for_steady_state              = true
  force_new_deployment               = true
  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }
  network_configuration {
    subnets          = var.ecs_subnets
    security_groups  = var.ecs_security_groups
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.alb_target_group.arn
    container_name   = "${var.name}-container"
    container_port   = var.container_port
  }

  lifecycle {
    ignore_changes = [desired_count]
  }
  depends_on = [aws_iam_role.ecs_exec_role]
}