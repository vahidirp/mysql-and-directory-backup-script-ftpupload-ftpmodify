#!/bin/bash
# Define the backup directory
BACKUP_DIR="/path/to/backup-directory"

# List of container names or IDs
CONTAINERS=("container1" "container2" "container3")

# MySQL/MariaDB credentials
DB_USER="your_db_user"
DB_PASSWORD="your_db_password"

# Email configuration
# SMTP configuration for sending email
SMTP_SERVER="your_smtp_server" # Change this variables
SMTP_PORT="your_smtp_port" # Change this variables
SMTP_USER="your_smtp_user" # Change this variables
SMTP_PASSWORD="your_smtp_password" # Change this variables
RECIPIENT_EMAIL="recipient@example.com" # Change this to your email address for success or unsuccess backup progress
SENDER_EMAIL="sender@example.com" # Can same as RECIPIENT_EMAIL
EMAIL_SUBJECT_PASS="Database Backup Pass" 
EMAIL_SUBJECT_FAILED="Database Backup Failed"

# Remove backup files and folders older than 4 days
find $BACKUP_DIR -type f -mtime +4 -exec rm {} \;
find $BACKUP_DIR -type d -empty -delete

# Loop through the containers and create backups
for CONTAINER in "${CONTAINERS[@]}"
do
   # Generate a timestamp for the backup file
   TIMESTAMP=$(date +%Y%m%d%H%M%S)

   # Define the backup file name
   BACKUP_FILE="${BACKUP_DIR}/${CONTAINER}_${TIMESTAMP}.sql"

   # Use mysqldump to create the backup
   docker exec -i ${CONTAINER} mysqldump -u${DB_USER} -p${DB_PASSWORD} --all-databases > ${BACKUP_FILE}

   # Check if the backup was successful
   if [ $? -eq 0 ]; then
       echo "Backup for ${CONTAINER} completed successfully: ${BACKUP_FILE}"
       # Send an email receipt
       echo "Backup for ${CONTAINER} completed successfully." | mail -s "${EMAIL_SUBJECT_PASS}" -a "From: ${SENDER_EMAIL}" -S smtp=smtp://${SMTP_SERVER}:${SMTP_PORT} -S smtp-use-starttls -S smtp-auth=login -S smtp-auth-user=${SMTP_USER} -S smtp-auth-password=${SMTP_PASSWORD} ${RECIPIENT_EMAIL}
   else
       echo "Backup for ${CONTAINER} failed"
       # Send an email notification
       echo "Backup for ${CONTAINER} failed." | mail -s "${EMAIL_SUBJECT_FAILED}" -a "From: ${SENDER_EMAIL}" -S smtp=smtp://${SMTP_SERVER}:${SMTP_PORT} -S smtp-use-starttls -S smtp-auth=login -S smtp-auth-user=${SMTP_USER} -S smtp-auth-password=${SMTP_PASSWORD} ${RECIPIENT_EMAIL}
   fi
done
