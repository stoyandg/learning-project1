output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "public_subnets_id" {
  value = aws_subnet.public_subnets.*.id
}

output "private_subnets_id" {
  value = aws_subnet.private_subnets.*.id
}

output "db_subnet_group" {
  value = var.enable_db_subnet_group ? aws_db_subnet_group.db_subnets[0].id : ""
}
