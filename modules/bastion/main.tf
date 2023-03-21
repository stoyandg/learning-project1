resource "aws_launch_configuration" "bastion-configuration"  {
    name_prefix = "${var.app-name}-bastion-configuration"
    image_id = "ami-0e35f2ebc8ed764ec"
    instance_type = "t2.micro"
    security_groups = var.vpc_public_security_group_ids
    key_name = "learning-project1-key-pair"
}

resource "aws_autoscaling_group" "bastion-autoscaling" {
    name = "${var.app-name}-bastion-autoscaling"
    launch_configuration = aws_launch_configuration.bastion-configuration.id
    desired_capacity = 1
    max_size = 1
    min_size = 1

    vpc_zone_identifier = var.both_public_subnets_id
}
