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

source "amazon-ebs" "bastion" {
  ami_name      = "packer-bastion-${var.app-name}"
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

  provisioner "shell" {
    inline = [
      "sudo yum update -y",
      "sudo hostnamectl set-hostname bastion-machine"
    ]
  }

  provisioner "file" {
    source      = "./scripts/learning-project1-keypair.pem"
    destination = "~/.ssh/"
  }
  
}