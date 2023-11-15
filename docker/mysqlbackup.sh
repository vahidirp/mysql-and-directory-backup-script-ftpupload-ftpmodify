#!/bin/bash
DATE=$(date +"%Y-%m-%d_%H-%M-%S")
DB_NAME_1="your_database_name"
DB_NAME_2="your_database_name"
# Set your MariaDB container name
DB_CONTAINER_1="your_mariadb_container_name"
DB_CONTAINER_2="your_mariadb_container_name"
# Set the backup directory
DB_DIR_1="/path/to/backup/directory"
DB_DIR_2="/path/to/backup/directory"
# Set DB's Username & Password for identity
DB1_User="your_database1_username"
DB1_Password="your_database1_password"
DB2_User="your_database2_username"
DB2_Password="your_database2_password"

# SMTP configuration for sending email
SMTP_SERVER="your_smtp_server" # Change this variables
SMTP_PORT="your_smtp_port" # Change this variables
SMTP_USER="your_smtp_user" # Change this variables
SMTP_PASSWORD="your_smtp_password" # Change this variables
RECIPIENT_EMAIL="recipient@example.com" # Change this to your email address for success or unsuccess backup progress
SENDER_EMAIL="sender@example.com" # Can same as RECIPIENT_EMAIL
EMAIL_SUBJECT_PASS="Database Backup Pass" 
EMAIL_SUBJECT_FAILED="Database Backup Failed"

mkdir -p "$DB_DIR_1"
mkdir -p "$DB_DIR_2"
# Docker exec command to run mysqldump inside the container and compress the backup
 docker exec -it $DB_CONTAINER_1 mysqldump --user=$DB1_User --password=$DB1_Password $DB_Name_1 | gzip > $DB_DIR_1/$DB_Name_1-${DATE}.gz
 docker exec -it $DB_CONTAINER_2 mysqldump --user=$DB2_User --password=$DB2_Password $DB_Name_2 | gzip > $DB_DIR_2/$DB_Name_2-${DATE}.gz
 if [ $? -eq 0 ]; then
  echo "MySQL/MariaDB database backup completed successfully" | mail -s "$EMAIL_SUBJECT_PASS" -a "From: $SENDER_EMAIL" -s smtp=smtp://$SMTP_SERVER:$SMTP_PORT -s smtp-use-starttls -s smtp-auth=login -s smtp-auth-user=$SMTP_USER -s smtp-auth-password=$SMTP_PASSWORD $RECIPIENT_EMAIL
else
  echo "MySQL/MariaDB database backup failed" | mail -s "$EMAIL_SUBJECT_FAILED" -a "From: $SENDER_EMAIL" -s smtp=smtp://$SMTP_SERVER:$SMTP_PORT -s smtp-use-starttls -s smtp-auth=login -s smtp-auth-user=$SMTP_USER -s smtp-auth-password=$SMTP_PASSWORD $RECIPIENT_EMAIL
fi
# Use the 'find' command to locate and delete old backup files (4 days or older)
find "$DB_DIR_1" -ctime +4 -exec rm -rf {} \;
find "$DB_DIR_2" -ctime +4 -exec rm -rf {} \;
# Optionally, you can print a message indicating the cleanup is complete
echo "Cleanup completed."
