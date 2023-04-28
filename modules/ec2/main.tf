resource "aws_instance" "ec2" {
  ami                    = var.image_id
  instance_type          = var.instance_type
  availability_zone      = var.az
  vpc_security_group_ids = var.vpc_grafana_security_group_ids
  associate_public_ip_address = var.associate_public_ip_address
  subnet_id              = element(var.public_subnets_id, 0)
  private_ip             = var.private_ip 
  key_name               = var.key_name
  user_data = (base64encode(<<EOF
${var.user_data}
EOF
  ))
}