# aws-terraform-rds-aws-backup-multi-master-slaves

# Initial Deployment

```bash

```
# SSM Parameters

* endpoint - The master read/write endpoint. String.
* username - MariaDB root user. String.
* password - MariaDB root user password. String.
* slaves_endpoints - List of read only slaves endpoint. List of strings.

# Notes

* In order for the slaves to be created automatic backups must be enabled on the master.