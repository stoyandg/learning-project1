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

source "amazon-ebs" "apache" {
  ami_name      = "packer_apache_${var.app_name}"
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
    "Name"       = "MyApacheImage"
    "OS_Version" = "Amazon Linux 2"
    "Release"    = "Latest"
    "Created-by" = "Packer"
  }
}
build {
  sources = [
    "source.amazon-ebs.apache"
  ]

  provisioner "shell" {
    inline = [
      "sudo yum update -y",
      "sudo amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2",
      "sudo yum install -y httpd mariadb-server",
      "sudo usermod -a -G apache ec2-user",
      "sudo chown -R ec2-user:apache /var/www",
      "sudo chmod 2775 /var/www",
      "find /var/www -type d -exec sudo chmod 2775 {} \\;",
      "find /var/www -type f -exec sudo chmod 0664 {} \\;"
    ]
  }

  provisioner "file" {
    source      = "./scripts/test.php"
    destination = "/tmp/"
  }

    provisioner "file" {
    source = "./scripts/node-exporter.service"
    destination = "/tmp/"
  }


  provisioner "shell" {
    inline = [
      "sudo cp /tmp/test.php /var/www/html/",
      "sudo systemctl enable httpd",
      "sudo systemctl start httpd",
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
