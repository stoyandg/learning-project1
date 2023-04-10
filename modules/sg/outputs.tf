output "vpc_public_security_group_ids" {
  value = aws_security_group.Security_Group_Public.id
}

output "vpc_private_security_group_ids" {
  value = aws_security_group.Security_Group_Private.id
}

output "vpc_prometheus_security_group_ids" {
  value = aws_security_group.Security_Group_Prometheus.id
}

output "vpc_grafana_security_group_ids" {
  value = aws_security_group.Security_Group_Grafana.id
}

output "vpc_rds_security_group_ids" {
  value = aws_security_group.Security_Group_RDS.id
}
