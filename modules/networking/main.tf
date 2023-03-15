data "aws_availability_zones" "available" {}

# Creates a VPC
resource "aws_vpc" "vpc" {
    cidr_block = var.cidr

    tags = {
        Name = "${var.app-name}-VPC"
    }
}

# Creates 3 public subnets in the VPC"
resource "aws_subnet" "public_subnets" {
    count = length(var.public_subnets_list)

    vpc_id = var.id_of_vpc
    map_public_ip_on_launch = true
    cidr_block = var.public_subnets_list[count.index]
    availability_zone = var.availability_zones[count.index]

    tags = {
        Name = "${var.app-name}-Public-Subnet"
    }
}

# Creates 3 private subnets in the VPC
resource "aws_subnet" "private_subnets" {
    count = length(var.private_subnets_list)

    vpc_id = var.id_of_vpc
    map_public_ip_on_launch = true
    cidr_block = var.private_subnets_list[count.index]
    availability_zone = var.availability_zones[count.index]

    tags = {
        Name = "${var.app-name}-Private-Subnet"
    }
}

# Creates DB Subnet group
resource "aws_db_subnet_group" "db_subnets" {
    name = "${var.app-name}-db-subnets"

    subnet_ids = flatten([aws_subnet.private_subnets.*.id])

    tags = {
        Name = "${var.app-name}-DB-Subnet-Group"
    }

}

# Creates an Internet Gateway in the VPC
resource "aws_internet_gateway" "ig" {
    vpc_id = var.id_of_vpc

    tags = {
        Name = "${var.app-name}-Internet-Gateway"
    }
}

# Creates a route table in the VPC
resource "aws_route_table" "public_routetable" {
    vpc_id = var.id_of_vpc

    route {
        cidr_block = var.route_cidr_block
        gateway_id = aws_internet_gateway.ig.id
    }

    depends_on = [
      aws_internet_gateway.ig
    ]

    tags = {
        Name = "${var.app-name}-Public-Route-Table"
    }
}

# Associates the route table with the public subnets
resource "aws_route_table_association" "associations" {
    count = length(var.public_subnets_list)

    subnet_id = element(aws_subnet.public_subnets.*.id, count.index)
    route_table_id = aws_route_table.public_routetable.id
}