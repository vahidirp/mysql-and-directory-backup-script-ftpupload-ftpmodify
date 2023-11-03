#Name of your App/Web project
DATE=$(date +"%Y-%m-%d_%H-%M-%S")
DIR1="directory to save backup/app or domain or web name" #change this variables, this for save backup file for example: DIR1="/home/app&web-backup/vahid.community/"
BACKUP_DIR="/path/to/app_or_web_root_directory" #change this variables, this for zip and backup of your app or web root directory. example: /home/app&web/vahid.community
EMAIL="your@email.com"  # Change this to your email address for success or unsuccess backup progress
TARGET_DIR_1="$DIR1" #This variable for control space and delete files that are for more than somedays
mkdir -p "$TARGET_DIR_1"

zip -r "$TARGET_DIR_1/$DATE.zip" "$BACKUP_DIR" 

# Check if the backup was successful
if [ $? -eq 0 ]; then
  echo "Backup completed successfully" | mail -s "Backup Status" "$EMAIL"
else
  echo "Backup failed" | mail -s "Backup Status" "$EMAIL"
fi
# Use the 'find' command to locate and delete old backup files (4 days or older)
find "$TARGET_DIR_1" -type f -ctime +4 -exec rm -f {} \;

# Optionally, you can print a message indicating the cleanup is complete
echo "Cleanup completed."
