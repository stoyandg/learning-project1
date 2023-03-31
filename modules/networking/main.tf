# Creates a VPC
resource "aws_vpc" "vpc" {
    cidr_block = var.cidr

    tags = {
        Name = "${var.app-name}-VPC"
    }
}

# Creates public subnets in the VPC"
resource "aws_subnet" "public_subnets" {
    count = length(var.public_subnets_list)

    vpc_id = aws_vpc.vpc.id
    map_public_ip_on_launch = true
    cidr_block = var.public_subnets_list[count.index]
    availability_zone = var.availability_zones[count.index]

    tags = {
        Name = "${var.app-name}-Public-Subnet"
    }
}

# Creates private subnets in the VPC
resource "aws_subnet" "private_subnets" {
    count = length(var.private_subnets_list)

    vpc_id = aws_vpc.vpc.id
    map_public_ip_on_launch = true
    cidr_block = var.private_subnets_list[count.index]
    availability_zone = var.availability_zones[count.index]

    tags = {
        Name = "${var.app-name}-Private-Subnet"
    }
}

# Creates DB Subnet group
resource "aws_db_subnet_group" "db_subnets" {
    count = var.enable_db_subnets ? 1 : 0
    name = "${var.app-name}-db-subnets"

    subnet_ids = flatten([aws_subnet.private_subnets.*.id])

    tags = {
        Name = "${var.app-name}-DB-Subnet-Group"
    }

}

# Creates an Internet Gateway in the VPC
resource "aws_internet_gateway" "ig" {
    vpc_id = aws_vpc.vpc.id

    tags = {
        Name = "${var.app-name}-Internet-Gateway"
    }
}

# Creates 3 NAT gateways in each of the public subnets
resource "aws_nat_gateway" "nat" {
  count = var.just_count
  subnet_id = element(aws_subnet.public_subnets.*.id, count.index)
  allocation_id = element(aws_eip.elastic_ip.*.id, count.index)
  tags = {
    Name = "${var.app-name}-NAT-Gateways"
  }
}

# Creates 3 Elastic IPs so the NAT gateways can have static IPs
resource "aws_eip" "elastic_ip" {
  count = var.just_count
  vpc = true
  depends_on = [aws_internet_gateway.ig]
  tags = {
    Name = "${var.app-name}-Elastic-IPs"
  }
}

# Creates a public route table in the VPC
resource "aws_route_table" "public_routetable" {
    vpc_id = aws_vpc.vpc.id

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

# Creates a private route table in the VPC
resource "aws_route_table" "private_routetable" {
  count = var.just_count
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = var.route_cidr_block
    nat_gateway_id = element(aws_nat_gateway.nat.*.id, count.index)
  }

  depends_on = [aws_nat_gateway.nat]
  tags = {
    Name = "${var.app-name}-Private-RouteTable"
  }
}

# Associates the public route table with the public subnets
resource "aws_route_table_association" "associations" {
    count = length(var.public_subnets_list)

    subnet_id = element(aws_subnet.public_subnets.*.id, count.index)
    route_table_id = aws_route_table.public_routetable.id
}

# Associates the private route table with the public subnets
resource "aws_route_table_association" "private_associations" {
  count = length(var.private_subnets_list)

  subnet_id = element(aws_subnet.private_subnets.*.id, count.index)
  route_table_id = element(aws_route_table.private_routetable.*.id, count.index)
}