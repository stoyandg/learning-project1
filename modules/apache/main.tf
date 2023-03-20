data "aws_ami" "latest_amazon_linux" {
    owners = ["amazon"]
    most_recent = true
    filter {
        name = "name"
        values = ["amzn2-ami-kernel-5.10-hvm-*-x86_64-gp2"]
    }
}

resource "aws_launch_configuration" "apache-configuration"  {
    name_prefix = "${var.app-name}-apache-configuration"
    image_id = "ami-0d67b65cdac5ecbc1"
    instance_type = "t2.micro"
    security_groups = var.vpc_public_security_group_ids
    iam_instance_profile = aws_iam_instance_profile.ec2-to-aurora-profile.name
    key_name = "learning-project1-key-pair"
}

resource "aws_autoscaling_group" "apache-autoscaling" {
    name = "${var.app-name}-apache-autoscaling"
    launch_configuration = aws_launch_configuration.apache-configuration.id
    desired_capacity = 3
    max_size = 3
    min_size = 3

    vpc_zone_identifier = var.both_public_subnets_id
}