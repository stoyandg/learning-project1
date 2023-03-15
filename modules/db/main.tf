resource "aws_rds_cluster" "db_cluster" {
    cluster_identifier = "${var.app-name}-db-cluster"
    availability_zones = ["us-west-2a", "us-west-2b", "us-west-2c"]
    engine = "aurora"
    database_name = "dbname"
    db_subnet_group_name = var.both_db_subnets_name
    vpc_security_group_ids = var.vpc_private_security_group_ids
    master_username = "stoyandg"
    master_password = "${var.master_password}"
    skip_final_snapshot = true
}

resource "aws_rds_cluster_instance" "db_instance" {
    count = 3

    identifier = "${var.app-name}-aurora-cluster-${count.index}"
    cluster_identifier = aws_rds_cluster.db_cluster.id
    instance_class = "db.t3.small"
    engine = aws_rds_cluster.db_cluster.engine
    db_subnet_group_name = aws_rds_cluster.db_cluster.db_subnet_group_name
}