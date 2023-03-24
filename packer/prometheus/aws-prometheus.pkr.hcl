variable "region" {
  type    = string
  default = "us-west-2"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "app-name" {
  type    = string
  default = "learning-project1-app"
}

source "amazon-ebs" "prometheus" {
  ami_name      = "packer-prometheus-${var.app-name}"
  instance_type = var.instance_type
  region        = var.region
  source_ami_filter {
    filters = {
      name                = "amzn2-ami-kernel-5.10-hvm-*-x86_64-gp2"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["amazon"]
  }
  ssh_username = "ec2-user"
  tags = {
    "Name"       = "MyPrometheusImage"
    "OS_Version" = "Amazon Linux 2"
    "Release"    = "Latest"
    "Created-by" = "Packer"
  }
}
build {
  sources = [
    "source.amazon-ebs.prometheus"
  ]


    provisioner "file" {
    source      = "./scripts/"
    destination = "/tmp/"
  }

    provisioner "shell" {
    inline = [
      "sudo yum update -y",
      "sudo cp /tmp/prometheus.repo /etc/yum.repos.d/",
      "sudo yum -y install prometheus2 node_exporter",
      "sudo rm -f /etc/prometheus/prometheus.yml",
      "sudo cp /tmp/prometheus.yml /etc/prometheus/",
      "sudo systemctl enable prometheus node_exporter",
      "sudo systemctl restart prometheus node_exporter",
      "sudo rm -f /tmp/prometheus.repo /tmp/prometheus.yml"
    ]
  }
}