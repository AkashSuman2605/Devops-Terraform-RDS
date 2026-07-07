# Devops-Terraform-RDS

This project provisions AWS infrastructure using Terraform and manages a MySQL database using Docker.

---

# Terraform Backend

Terraform is configured to use:

- Amazon S3 for remote state storage
- DynamoDB for state locking

Development state:

```
dev/terraform.tfstate
```

Production state:

```
prod/terraform.tfstate
```

> Note: If S3 and DynamoDB are not configured yet, Terraform will use the local backend during testing.

---

# Database Backup

Run:

```bash
./database/backup.sh
```

This creates a timestamped SQL backup.

Example backup file:

```
backups/backup_20260707_183500.sql
```

---

# Database Restore

Restore a specific backup by running:

```bash
./database/restore.sh backups/backup_20260707_183500.sql
```

The script reads the SQL statements from the backup file and restores them into the `hoteldb` database.

---

# Verify Restore

Login to MySQL:

```bash
docker exec -it mysql-db mysql -uroot -proot123
```

Select the database:

```sql
USE hoteldb;
```

Verify the tables:

```sql
SHOW TABLES;
```

Check booking records:

```sql
SELECT COUNT(*) FROM hotel_bookings;
```

Check booking events:

```sql
SELECT COUNT(*) FROM booking_events;
```

If both tables exist and the record count is displayed, the restore operation was successful.
