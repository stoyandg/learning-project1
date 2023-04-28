resource "aws_launch_template" "bastion_template" {
  name_prefix = "${var.app_name}_bastion_template"

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size           = 8
      volume_type           = "gp2"
      delete_on_termination = true
    }
  }

  vpc_security_group_ids = var.vpc_public_security_group_ids
  image_id               = "ami-051270933c06fc174"
  instance_type          = "t2.micro"
  key_name               = "learning-project1-key-pair"

  user_data = (base64encode(<<EOF
#!/bin/bash
hostnamectl set-hostname bastion
EOF
  ))
}

resource "aws_autoscaling_group" "bastion_autoscaling" {
  name = "${var.app_name}_bastion_autoscaling"
  launch_template {
    id = aws_launch_template.bastion_template.id
  }
  desired_capacity = 1
  max_size         = 1
  min_size         = 1

  health_check_type = "EC2"
  target_group_arns = [
    aws_lb_target_group.bastion_lb_tg.id
  ]

  vpc_zone_identifier = var.public_subnets_id
}
