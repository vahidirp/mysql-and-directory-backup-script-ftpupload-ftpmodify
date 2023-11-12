#!/bin/bash
# FTP server details
ftp_server="ftp.example.com" 
ftp_user="your_username"
ftp_pass="your_password"

# FTP directory to clean
ftp_directory="/app&web/vahid.community" #change this variable to directory on ftp that you want to upload and control
local_directory="/path/to/local/directory"  #change this variable to local directory of your backup files
# Define the maximum age of files to keep in days
max_age_days=30 #change this variables for delete files older that some days for example for delete more than 4 days : max_age_days=4

# SMTP configuration for sending email
SMTP_SERVER="your_smtp_server" # Change this variables
SMTP_PORT="your_smtp_port" # Change this variables
SMTP_USER="your_smtp_user" # Change this variables
SMTP_PASSWORD="your_smtp_password" # Change this variables
RECIPIENT_EMAIL="recipient@example.com" # Change this to your email address for success or unsuccess backup progress
SENDER_EMAIL="sender@example.com" # Can same as RECIPIENT_EMAIL
EMAIL_SUBJECT="Upload To FTP" 
message="The upload and cleanup process is complete."

# Ensure the local directory exists
if [ ! -d "$local_directory" ]; then
  echo "Local directory does not exist: $local_directory"
  exit 1
fi

# Connect to the FTP server
lftp -u "$ftp_user","$ftp_pass" "$ftp_server" <<EOF
    # Change to the FTP directory
    cd "$ftp_directory"

    # Calculate the cutoff date (files older than this will be removed)
    cutoff_date=$(date -d "$max_age_days days ago" +%Y%m%d)
            
    # List files in the directory
    ls

    # Loop through the files in the directory
    for file in $(ls -1); do
        # Extract the file modification date
        file_date=$(date -r "$file" +%Y%m%d)
        
        # Compare the file date with the cutoff date
        if [ "$file_date" -lt "$cutoff_date" ]; then
            echo "Removing file $file (modified on $file_date)"
            
            # Delete the file
            rm "$file"
        fi
    done

    # Exit FTP session
    exit
EOF

# Create the remote directory if it doesn't exist
lftp -e "mkdir -p $ftp_directory; bye" -u "$ftp_user","$ftp_password" "$ftp_server"

# Upload files and directories
lftp -e "mirror -R --reverse --delete-first $local_directory $ftp_directory; bye" -u "$ftp_user","$ftp_password" "$ftp_server"

# Send email notification
echo "$message" | mail -s "$EMAIL_SUBJECT" -a "From: $SENDER_EMAIL" -S smtp=smtp://$SMTP_SERVER:$SMTP_PORT -S smtp-use-starttls -S smtp-auth=login -S smtp-auth-user=$SMTP_USER -S smtp-auth-password=$SMTP_PASSWORD $RECIPIENT_EMAIL

echo "Cleanup and upload completed. Email notification sent."
