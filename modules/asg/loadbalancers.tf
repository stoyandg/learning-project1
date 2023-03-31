resource "aws_lb" "network_loadbalancer" {
  count              = var.enable_network_load_balancer ? 1 : 0
  name               = var.name
  internal           = var.internal_load_balancer
  load_balancer_type = "network"

  enable_cross_zone_load_balancing = var.enable_cross_zone_load_balancing

  dynamic "subnet_mapping" {
    for_each = var.loadbalancer_subnet_ids
    content {
      subnet_id = subnet_mapping.value
    }
  }
}

resource "aws_lb_listener" "network_loadbalancer_listener" {
  count             = var.enable_network_load_balancer ? 1 : 0
  load_balancer_arn = aws_lb.network_loadbalancer[0].id
  port              = var.loadbalancer_port
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.id
  }
}

resource "aws_lb" "application_loadbalancer" {
  count              = var.enable_application_load_balancer ? 1 : 0
  name               = var.name
  internal           = var.internal_load_balancer
  load_balancer_type = "application"
  subnets            = var.loadbalancer_subnet_ids
  security_groups    = var.public_security_group_ids
}

resource "aws_lb_listener" "application_loadbalancer_listener" {
  count             = var.enable_application_load_balancer ? 1 : 0
  load_balancer_arn = aws_lb.application_loadbalancer[0].id
  port              = var.loadbalancer_port
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.id
  }
}

resource "aws_lb_target_group" "target_group" {
  name_prefix = var.name
  port        = var.loadbalancer_port
  protocol    = "TCP"
  vpc_id      = var.vpc_id

  health_check {
    port     = var.health_check_port
    protocol = "TCP"
  }
}

resource "aws_autoscaling_attachment" "asg_attachment_bastion" {
  autoscaling_group_name = aws_autoscaling_group.autoscaling.id
  lb_target_group_arn    = aws_lb_target_group.target_group.arn
}
