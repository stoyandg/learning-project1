resource "aws_launch_template" "apache-template" {
  name_prefix = "${var.app-name}-apache-template"

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = 8
      volume_type = "gp2"
      delete_on_termination = true
    }
  }

  vpc_security_group_ids = var.vpc_private_security_group_ids

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2-to-aurora-profile.name
  }

  image_id = "ami-06143a412c31d644f"
  instance_type = "t2.micro"
  key_name = "learning-project1-key-pair"

  user_data = "${base64encode(<<EOF
#!/bin/bash
hostnamectl set-hostname apache
EOF
)}"
}



resource "aws_autoscaling_group" "apache-autoscaling" {
    name = "${var.app-name}-apache-autoscaling"
    launch_template {
        id = aws_launch_template.apache-template.id
    }
    desired_capacity = 3
    max_size = 3
    min_size = 3

    health_check_type = "EC2"
    target_group_arns = [
        aws_lb_target_group.apache-lb-tg.id
    ]

    vpc_zone_identifier = var.both_private_subnets_id
}