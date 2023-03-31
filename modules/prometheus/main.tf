resource "aws_instance" "prometheus" {
  ami                         = "ami-07165ef812e00b2a9"
  instance_type               = var.instance_type
  availability_zone           = var.az
  associate_public_ip_address = true
  vpc_security_group_ids      = var.vpc_prometheus_security_group_ids
  subnet_id                   = element(var.public_subnets_id, 0)
  key_name                    = "learning-project1-key-pair"
  private_ip                  = "10.0.1.10"
  user_data = (base64encode(<<EOF
#!/bin/bash
hostnamectl set-hostname prometheus
EOF
  ))
}