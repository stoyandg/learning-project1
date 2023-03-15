output "id_of_vpc" {
    value = aws_vpc.vpc.id
}

output "both_public_subnets_id" {
    value = aws_subnet.public_subnets.*.id
}

output "both_private_subnets_id" {
    value = aws_subnet.private_subnets.*.id
}

output "both_db_subnets_name" {
    value = aws_db_subnet_group.db_subnets.id
}