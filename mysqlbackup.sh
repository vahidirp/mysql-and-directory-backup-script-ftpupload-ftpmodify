#!/bin/bash

DB_USER="administrator-username or root" #change this variables
DB_PASS="administrator-password or root password" #change this variables
DB_1="yourDB_Name" #change this variables
DATE=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_DIR1="your directory that you want save backup/$DB_1" #change this variables for example : BACKUP_DIR1="/home/mysqlbackup/$DB_1"
# SMTP configuration for sending email
SMTP_SERVER="your_smtp_server" # Change this variables
SMTP_PORT="your_smtp_port" # Change this variables
SMTP_USER="your_smtp_user" # Change this variables
SMTP_PASSWORD="your_smtp_password" # Change this variables
RECIPIENT_EMAIL="recipient@example.com" # Change this to your email address for success or unsuccess backup progress
SENDER_EMAIL="sender@example.com" # Can same as RECIPIENT_EMAIL
EMAIL_SUBJECT_PASS="Database Backup Pass" 
EMAIL_SUBJECT_FAILED="Database Backup Failed"

TARGET_DIR_1="$BACKUP_DIR1"
mkdir -p "$TARGET_DIR_1"
mysqldump --user=$DB_USER --password=$DB_PASS $DB_1 > $BACKUP_DIR1/$DB_1-$DATE.sql
if [ $? -eq 0 ]; then
  gzip "$BACKUP_DIR1/$DB_1-$DATE.sql"
  echo "MySQL/MariaDB database backup completed successfully" | mail -s "$EMAIL_SUBJECT_PASS" -a "From: $SENDER_EMAIL" -S smtp=smtp://$SMTP_SERVER:$SMTP_PORT -S smtp-use-starttls -S smtp-auth=login -S smtp-auth-user=$SMTP_USER -S smtp-auth-password=$SMTP_PASSWORD $RECIPIENT_EMAIL
else
  echo "MySQL/MariaDB database backup failed" | mail -s "$EMAIL_SUBJECT_FAILED" -a "From: $SENDER_EMAIL" -S smtp=smtp://$SMTP_SERVER:$SMTP_PORT -S smtp-use-starttls -S smtp-auth=login -S smtp-auth-user=$SMTP_USER -S smtp-auth-password=$SMTP_PASSWORD $RECIPIENT_EMAIL
fi
# Use the 'find' command to locate and delete old backup files (4 days or older)
find "$TARGET_DIR_1" -ctime +4 -exec rm -rf {} \;
# Optionally, you can print a message indicating the cleanup is complete
echo "Cleanup completed."
