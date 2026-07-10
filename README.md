# Infrastructure as Code (Terraform) with MySQL Backup & Recovery

This project provisions AWS infrastructure using Terraform and sets up a MySQL database using Docker Compose.

The project includes:

- Terraform infrastructure
- Development and Production environments
- Local MySQL database
- Database schema
- Seed data
- Database indexing
- Backup and Restore scripts

---

# Project Structure

```
Devops-Terraform-RDS/

├── infra/
│   ├── envs/
│   │   ├── dev/
│   │   └── prod/
│   └── modules/
│
├── database/
│   ├── docker-compose.yml
│   ├── .env
│   ├── init.sql
│   ├── seed.sql
│   └── indexes.sql
│
├── scripts/
│   ├── backup.sh
│   └── restore.sh
│
├── README.md
├── providers.tf
├── variables.tf
└── terraform.tfvars
```

---
## Environment Setup(OPTIONAL)

For Amazon Linux 2023, a setup script is provided to install all required dependencies.

Run:

```bash
chmod +x setup.sh
./setup.sh
```

The script installs and configures:

- Git
- Docker
- Docker Compose
- Terraform

# Terraform

The infrastructure creates:

- VPC
- Public and Private Subnets
- Internet Gateway
- Route Tables
- ECS Security Group
- RDS MySQL Instance

Separate Terraform environments are available for:

- Development
- Production

The project also supports using an S3 backend with DynamoDB state locking. For local testing, the backend configuration is currently commented out.

---

# Local Database Setup

Go to the database directory:

```bash
cd database
```

Start MySQL using Docker Compose:

```bash
docker compose up -d
```

This automatically creates:

- hoteldb database
- hotel_bookings table
- booking_events table

Seed data is loaded from:

```
seed.sql
```

Indexes are created from:

```
indexes.sql
```

---

# Database Backup

Run:

```bash
./scripts/backup.sh
```

The script:

- creates the backups folder if it does not exist
- exports the complete database
- saves it with the current date and time

Example:

```
backups/backup_20260707_183500.sql
```

---

# Database Restore

Restore a backup by passing the backup file name.

Example:

```bash
./scripts/restore.sh backups/backup_20260707_183500.sql
```

The script reads the SQL statements from the backup file and restores them into the **hoteldb** database.

---

# Verify Restore

Login into MySQL:

```bash
docker exec -it hotel-mysql mysql -uroot -p
```

Select the database:

```sql
USE hoteldb;
```

Check the tables:

```sql
SHOW TABLES;
```

Verify booking data:

```sql
SELECT COUNT(*) FROM hotel_bookings;
```

Verify booking events:

```sql
SELECT COUNT(*) FROM booking_events;
```

If both tables exist and records are returned, the restore completed successfully.

---

# Query Optimization

A composite index has been created to optimize queries filtering by:

- city
- created_at

and grouping by:

- org_id
- status

This improves query performance by reducing the number of rows scanned.

---

# Notes

- Database configuration is stored in the `.env` file.
- Docker Compose reads the environment variables from `.env`.
- Backup files are stored inside the `backups/` directory.
