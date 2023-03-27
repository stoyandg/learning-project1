
# Creates a Security Group for the instances in the public subnet.
resource "aws_security_group" "Security_Group_Public" {
    name = "${var.app-name}-Public-Subnets-Security-Group"
    description = "Allows all incoming traffic and outgoing traffic for the specified ports"

    vpc_id = var.id_of_vpc

     ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["79.100.216.36/32"]
    }

    dynamic "ingress" {
        for_each = var.allowed_ports_public
        content {
            from_port = ingress.value
            to_port = ingress.value
            protocol = "tcp"
            cidr_blocks = ["0.0.0.0/0"]
        }
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

# Creates a Security Group for the instances in the private subnet.
resource "aws_security_group" "Security_Group_Private" {
    name = "${var.app-name}-Private-Subnets-Security-Group"
    description = "Allows incoming traffic only from instances in the public subnet and all outgoing traffic"

    vpc_id = var.id_of_vpc
    ingress {
        description = "Traffic from Public Subnet"
        from_port = 0
        to_port = 0
        protocol = "-1"
        security_groups = var.vpc_public_security_group_ids
    }

    ingress {
        description = "Traffic from Prometheus Instance"
        from_port = 0
        to_port = 0
        protocol = "-1"
        security_groups = var.vpc_prometheus_security_group_ids
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "Security_Group_Prometheus" {
    name = "${var.app-name}-Prometheus-Security-Group"
    description = "Allows incoming traffic on all Prometheus ports"

    vpc_id = var.id_of_vpc

    dynamic "ingress" {
        for_each = var.allowed_ports_prometheus
        content {
            from_port = ingress.value
            to_port = ingress.value
            protocol = "tcp"
            cidr_blocks = ["0.0.0.0/0"]
        }
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "Security_Group_Grafana" {
    name = "${var.app-name}-Grafana-Security-Group"

    vpc_id = var.id_of_vpc

     ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        security_groups = var.vpc_public_security_group_ids
    }

    ingress {
        from_port = 3000
        to_port = 3000
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    dynamic "ingress" {
        for_each = var.allowed_ports_public
        content {
            from_port = ingress.value
            to_port = ingress.value
            protocol = "tcp"
            cidr_blocks = ["0.0.0.0/0"]
        }
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

# Creates a Security Group for the database instances.
resource "aws_security_group" "Security_Group_RDS" {
    name = "${var.app-name}-RDS-Security-Group"
    description = "Allows incoming traffic only from instances in the private subnet and all outgoing traffic"

    vpc_id = var.id_of_vpc
    ingress {
        description = "Traffic from Public Subnet"
        from_port = 0
        to_port = 0
        protocol = "-1"
        security_groups = var.vpc_private_security_group_ids
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}