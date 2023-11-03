#!/bin/bash

DB_USER="administrator-username or root" #change this variables
DB_PASS="administrator-password or root password" #change this variables
DB_1="yourDB_Name" #change this variables
DATE=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_DIR1="your directory that you want save backup/$DB_1" #change this variables for example : BACKUP_DIR1="/home/mysqlbackup/$DB_1"
EMAIL="your@email.com"  # Change this to your email address for the notification that back is success or unsuccess.
TARGET_DIR_1="$BACKUP_DIR1"
mkdir -p "$TARGET_DIR_1"
mysqldump --user=$DB_USER --password=$DB_PASS $DB_1 > $BACKUP_DIR1/$DB_1-$DATE.sql
if [ $? -eq 0 ]; then
  gzip "$BACKUP_DIR1/$DB_1-$DATE.sql"
  echo "MySQL/MariaDB database backup completed successfully" | mail -s "Backup Status" "$EMAIL"
else
  echo "MySQL/MariaDB database backup failed" | mail -s "Backup Status" "$EMAIL"
fi
# Use the 'find' command to locate and delete old backup files (4 days or older)
find "$TARGET_DIR_1" -ctime +4 -exec rm -rf {} \;
# Optionally, you can print a message indicating the cleanup is complete
echo "Cleanup completed."
