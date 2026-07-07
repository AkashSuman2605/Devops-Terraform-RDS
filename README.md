# Devops-Terraform-RDS
## Terraform Backend

Terraform uses:

- Amazon S3 for remote state storage
- DynamoDB for state locking

Development State

dev/terraform.tfstate

Production State

prod/terraform.tfstate

# Database Backup

Run:

```bash
./scripts/backup.sh
```

This creates a timestamped SQL backup inside the backups folder.

Example:

backups/hoteldb_20260707_183500.sql

---

# Database Restore

Run:

```bash
./scripts/restore.sh
```

This restores the latest backup into the MySQL database.

---

# Verify Restore

After restoring:

```sql
USE hoteldb;

SHOW TABLES;

SELECT COUNT(*) FROM hotel_bookings;

SELECT COUNT(*) FROM booking_events;
```

If both tables exist and data is present, restore was successful.
