#Name of your App/Web project
DATE=$(date +"%Y-%m-%d_%H-%M-%S")
DIR1="directory to save backup/app or domain or web name" #change this variables, this for save backup file for example: DIR1="/home/app&web-backup/vahid.community/"
BACKUP_DIR="/path/to/app_or_web_root_directory" #change this variables, this for zip and backup of your app or web root directory. example: /home/app&web/vahid.community
# SMTP configuration for sending email
SMTP_SERVER="your_smtp_server" # Change this variables
SMTP_PORT="your_smtp_port" # Change this variables
SMTP_USER="your_smtp_user" # Change this variables
SMTP_PASSWORD="your_smtp_password" # Change this variables
RECIPIENT_EMAIL="recipient@example.com" # Change this to your email address for success or unsuccess backup progress
SENDER_EMAIL="sender@example.com" # Can same as RECIPIENT_EMAIL
EMAIL_SUBJECT_PASS="Database Backup Pass" 
EMAIL_SUBJECT_FAILED="Database Backup Failed"

TARGET_DIR_1="$DIR1" #This variable for control space and delete files that are for more than somedays
mkdir -p "$TARGET_DIR_1"

zip -r "$TARGET_DIR_1/$DATE.zip" "$BACKUP_DIR" 

# Check if the backup was successful
if [ $? -eq 0 ]; then
  echo "Backup completed successfully" | mail -s "$EMAIL_SUBJECT_PASS" -a "From: $SENDER_EMAIL" -S smtp=smtp://$SMTP_SERVER:$SMTP_PORT -S smtp-use-starttls -S smtp-auth=login -S smtp-auth-user=$SMTP_USER -S smtp-auth-password=$SMTP_PASSWORD $RECIPIENT_EMAIL
else
  echo "Backup failed" | mail -s "$EMAIL_SUBJECT_FAILED" -a "From: $SENDER_EMAIL" -S smtp=smtp://$SMTP_SERVER:$SMTP_PORT -S smtp-use-starttls -S smtp-auth=login -S smtp-auth-user=$SMTP_USER -S smtp-auth-password=$SMTP_PASSWORD $RECIPIENT_EMAIL
fi
# Use the 'find' command to locate and delete old backup files (4 days or older)
find "$TARGET_DIR_1" -ctime +4 -exec rm -rf {} \;

# Optionally, you can print a message indicating the cleanup is complete
echo "Cleanup completed."
