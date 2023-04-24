resource "aws_rds_cluster" "db_cluster" {
  cluster_identifier     = "${var.app_name}-db-cluster"
  availability_zones     = var.availability_zones
  engine                 = var.engine
  engine_mode            = "provisioned"
  database_name          = var.database_name
  db_subnet_group_name   = var.db_subnet_group
  vpc_security_group_ids = var.vpc_rds_security_group_ids
  master_username        = var.master_username
  master_password        = var.master_password
  skip_final_snapshot    = true
}

resource "aws_rds_cluster_instance" "db_instance" {
  count = var.rds_cluster_instance_count

  identifier           = "${var.app_name}-${var.engine}-cluster-${count.index}"
  cluster_identifier   = aws_rds_cluster.db_cluster.id
  instance_class       = var.instance_class
  engine               = aws_rds_cluster.db_cluster.engine
  db_subnet_group_name = aws_rds_cluster.db_cluster.db_subnet_group_name
}
