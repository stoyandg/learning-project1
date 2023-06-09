resource "aws_lb" "bastion-lb" {
  name               = "${var.app-name}-bastion-lb"
  internal           = false
  load_balancer_type = "network"

  enable_cross_zone_load_balancing = true

  dynamic "subnet_mapping" {
    for_each = var.both_public_subnets_id
    content {
      subnet_id = subnet_mapping.value
    }
  }
}

resource "aws_lb_listener" "apache-lb-listener" {
  load_balancer_arn = aws_lb.bastion-lb.id
  port              = 22
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.bastion-lb-tg.id
  }
}

resource "aws_lb_target_group" "bastion-lb-tg" {
  name_prefix = "bast"
  port        = 22
  protocol    = "TCP"
  vpc_id      = var.id_of_vpc

  health_check {
    port     = 22
    protocol = "TCP"
  }
}

resource "aws_autoscaling_attachment" "asg_attachment_bastion" {
  autoscaling_group_name = aws_autoscaling_group.bastion-autoscaling.id
  lb_target_group_arn    = aws_lb_target_group.bastion-lb-tg.arn
}
