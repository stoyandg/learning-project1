resource "aws_launch_template" "apache_template" {
  name_prefix = "${var.app_name}_apache_template"

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size           = 8
      volume_type           = "gp2"
      delete_on_termination = true
    }
  }

  vpc_security_group_ids = var.vpc_private_security_group_ids

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_to_aurora_profile.name
  }

  image_id      = "ami-0a8b8f320c122619d"
  instance_type = "t2.micro"
  key_name      = "learning-project1-key-pair"

  user_data = (base64encode(<<EOF
#!/bin/bash
hostnamectl set-hostname apache
EOF
  ))
}

resource "aws_autoscaling_group" "apache_autoscaling" {
  name = "${var.app_name}-apache_autoscaling"
  launch_template {
    id = aws_launch_template.apache_template.id
  }
  desired_capacity = 3
  max_size         = 3
  min_size         = 3

  health_check_type = "EC2"
  target_group_arns = [
    aws_lb_target_group.lb_tg.id
  ]

  vpc_zone_identifier = var.private_subnets_id
}