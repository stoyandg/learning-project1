output "vpc_public_security_group_ids" {
    value = aws_security_group.Security_Group_Public.id
}

output "vpc_private_security_group_ids" {
    value = aws_security_group.Security_Group_Private.id
}