variable "region" {
  type    = string
  default = "us-west-2"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "app_name" {
  type    = string
  default = "learning-project1-app"
}

source "amazon-ebs" "bastion" {
  ami_name      = "packer_bastion_${var.app_name}"
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
    "Name"       = "MyBastionImage"
    "OS_Version" = "Amazon Linux 2"
    "Release"    = "Latest"
    "Created-by" = "Packer"
  }
}
build {
  sources = [
    "source.amazon-ebs.bastion"
  ]

  provisioner "file" {
    source      = "./scripts/learning-project1-keypair.pem"
    destination = "~/.ssh/"
  }

  provisioner "file" {
    source = "./scripts/node-exporter.service"
    destination = "/tmp/"
  }

    provisioner "shell" {
    inline = [
      "sudo yum update -y",
      "sudo mv /tmp/node-exporter.service /etc/systemd/system/",
      "sudo useradd --no-create-home node_exporter",
      "wget https://github.com/prometheus/node_exporter/releases/download/v1.0.1/node_exporter-1.0.1.linux-amd64.tar.gz",
      "tar xzf node_exporter-1.0.1.linux-amd64.tar.gz",
      "sudo cp node_exporter-1.0.1.linux-amd64/node_exporter /usr/local/bin/node_exporter",
      "rm -rf node_exporter-1.0.1.linux-amd64.tar.gz node_exporter-1.0.1.linux-amd64",
      "sudo systemctl daemon-reload",
      "sudo systemctl enable node-exporter",
      "sudo systemctl start node-exporter"
    ]
  }
}