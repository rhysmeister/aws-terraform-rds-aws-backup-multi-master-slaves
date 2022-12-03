# aws-terraform-rds-aws-backup-multi-master-slaves

# Initial Deployment

Ensure all local variables are as desired...

```bash
terraform apply
```

# Restore from Snapshot

It is important that the RDS instance was created with the `delete_automatic_backups` variable set to false. We will delete the instance before restoring a backup. If `delete_automatic_backups`is set to true all backups would be deleted when the instance was deleted. Take a manual backup for insurance if there's anything important contained in the db.

First destroy the db instance...

```bash
terraform destroy
```

Next in the Web Console got to

* RDS > Automated backups > Retained > rds1
* Copy an appropriate snapshot arn
* Paste this into the `snapshot_identifier`local variable in the Terraform code.

```bash
terraform apply
```

# SSM Parameters

* endpoint - The master read/write endpoint. String.
* username - MariaDB root user. String.
* password - MariaDB root user password. String.
* slaves_endpoints - List of read only slaves endpoint. List of strings.

# Notes

* In order for the slaves to be created automatic backups must be enabled on the master.
* Disassociating a backup does not delete it but it might take some time to appear in RDS > Automated backups > Retained backups. Ensure that delete_automated_backups is set to false before deleting the RDS instance.
* We want to support PITR as well as snapshot restore in this module. The restore_to_point_in_time block needs to be dynamic for this to work properly. Creating the block with all null values causes terraform to crash. 