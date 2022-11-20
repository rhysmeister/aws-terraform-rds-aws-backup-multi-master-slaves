locals {
    allocated_storage        = 10
    engine                   = "mariadb"
    engine_version           = "10.6"
    instance_class           = "db.t3.micro"
    skip_final_snapshot      = true
    multi_az                 = true
    backup_window            = "20:41-22:41"
    backup_retention_period  = 1
    delete_automated_backups = false

    username = "admin"
    password = "TopSecret915!"           
    
    snapshot_identifier = null

    slave_count = 3
}

resource "aws_db_instance" "rds1" {
    identifier               = "rds1"
    allocated_storage        = local.allocated_storage
    engine                   = local.engine
    engine_version           = local.engine_version
    instance_class           = local.instance_class
    username                 = local.username
    password                 = local.password
    skip_final_snapshot      = local.skip_final_snapshot
    multi_az                 = local.multi_az
    backup_window            = local.backup_window
    backup_retention_period  = local.backup_retention_period
    delete_automated_backups = local.delete_automated_backups

    snapshot_identifier      = local.snapshot_identifier
}

resource "aws_db_instance" "rds_slave" {
    count                    = local.slave_count
    identifier               = "rds1-slave-${count.index + 1}"
    instance_class           = local.instance_class
    skip_final_snapshot      = local.skip_final_snapshot
    delete_automated_backups = local.delete_automated_backups

   replicate_source_db =  aws_db_instance.rds1.identifier
}

resource "aws_ssm_parameter" "endpoint" {
    name        = "/test/rds/endpoint"
    description = "Endpoint of the active RDS Instance"
    type        = "String"
    value       = aws_db_instance.rds1.endpoint
}

resource "aws_ssm_parameter" "admin_username" {
    name        = "/test/rds/username"
    description = "Username of RDS Instance"
    type        = "String"
    value       = local.username
}

resource "aws_ssm_parameter" "admin_password" {
    name        = "/test/rds/password"
    description = "Password of RDS Instance"
    type        = "SecureString"
    value       = local.password
}

resource "aws_ssm_parameter" "slave_endpoints" {
    name  = "/test/rds/slave_endpoints"
    type = "String"
    value = jsonencode(aws_db_instance.rds_slave.*.endpoint)
}