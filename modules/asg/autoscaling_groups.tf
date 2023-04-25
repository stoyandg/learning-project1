locals {
  target_group_arns = var.enable_network_load_balancer ? [aws_lb_target_group.target_group_nlb[0].id] : (var.enable_application_load_balancer ? [aws_lb_target_group.target_group_alb[0].id] : [])
}

resource "aws_launch_template" "template" {
  name_prefix = var.name

  block_device_mappings {
    device_name = var.device_name
    ebs {
      volume_size           = var.volume_size
      volume_type           = var.volume_type
      delete_on_termination = var.volume_delete_on_termination
    }
  }

  vpc_security_group_ids = var.public_security_group_ids
  image_id               = var.image_id
  instance_type          = var.instance_type
  key_name               = var.key_name

  user_data = (base64encode(<<EOF
${var.user_data}
EOF
  ))
}

resource "aws_autoscaling_group" "autoscaling" {
  name = var.name
  launch_template {
    id = aws_launch_template.template.id
  }
  desired_capacity = var.desired_capacity
  max_size         = var.max_size_capacity
  min_size         = var.min_size_capacity

  health_check_type = var.health_check_type
  target_group_arns = local.target_group_arns

  vpc_zone_identifier = var.autoscaling_group_subnet_ids
}
