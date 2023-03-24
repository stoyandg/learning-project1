resource "aws_instance" "prometheus" {
    ami = "ami-05e0356f34a194400"
    instance_type = var.instance_type
    availability_zone = var.az
    associate_public_ip_address = true
    vpc_security_group_ids = var.vpc_prometheus_security_group_ids
    subnet_id = element(var.both_public_subnets_id, 0)
    key_name = "learning-project1-key-pair"
}