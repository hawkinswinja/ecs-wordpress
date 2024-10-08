# Application load balancer through port 443

resource "aws_lb" "alb" {
  name                             = "${var.name}-alb"
  internal                         = false #tfsec:ignore:aws-elb-alb-not-public
  load_balancer_type               = "application"
  security_groups                  = var.alb_security_group
  subnets                          = var.alb_subnets
  enable_deletion_protection       = false
  enable_http2                     = true
  idle_timeout                     = 30
  enable_cross_zone_load_balancing = true
  drop_invalid_header_fields       = true
  tags = {
    Name = "${var.name}-alb"
  }
}

resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-2017-01"
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_target_group.arn
  }
}

resource "aws_lb_target_group" "alb_target_group" {
  name        = "${var.name}-alb-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id
  health_check {
    path     = "/"
    protocol = "HTTP"
    port     = "traffic-port"
    matcher  = "200-399"
  }
}