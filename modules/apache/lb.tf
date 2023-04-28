resource "aws_lb" "application_lb" {
  name               = "${var.app_name}_lb"
  internal           = false
  load_balancer_type = "application"
  subnets            = var.public_subnets_id
  security_groups    = var.vpc_public_security_group_ids
}

resource "aws_lb_listener" "lb_listener" {
  load_balancer_arn = aws_lb.application_lb.id
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb_tg.id
  }
}

resource "aws_lb_target_group" "lb_tg" {
  name_prefix = "apache"

  port     = 80
  protocol = "HTTP"

  vpc_id = var.vpc_id

  health_check {
    healthy_threshold   = "2"
    interval            = "30"
    protocol            = "HTTP"
    path                = "/test.php"
    port                = "80"
    matcher             = "200"
    unhealthy_threshold = 2
  }
}

resource "aws_autoscaling_attachment" "asg_attachment_apache" {
  autoscaling_group_name = aws_autoscaling_group.apache_autoscaling.id
  lb_target_group_arn    = aws_lb_target_group.lb_tg.arn
}
