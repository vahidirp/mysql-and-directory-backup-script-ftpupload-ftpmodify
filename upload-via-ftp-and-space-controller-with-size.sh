#!/bin/bash
# FTP server details
ftp_server="ftp.example.com"
ftp_user="your_username"
ftp_pass="your_password"

# FTP directory to monitor
ftp_directory="/app&web-backup/vahid.community" #change this variables to directory that you want to control
local_directory="/path/to/local/directory"  #change this variable to local directory of your backup files

# Maximum allowed space in megabytes
LIMIT_MB=100 #change this variables to find files that are larger more than something 1024mb=fix1GB

# SMTP configuration for sending email
SMTP_SERVER="your_smtp_server" # Change this variables
SMTP_PORT="your_smtp_port" # Change this variables
SMTP_USER="your_smtp_user" # Change this variables
SMTP_PASSWORD="your_smtp_password" # Change this variables
RECIPIENT_EMAIL="recipient@example.com" # Change this to your email address for success or unsuccess backup progress
SENDER_EMAIL="sender@example.com" # Can same as RECIPIENT_EMAIL
EMAIL_SUBJECT="Upload To FTP" 
message="The upload and cleanup process is complete."

# Get the current used space in the remote directory
USED_SPACE=$(ncftp -u "$ftp_user" -p "$ftp_pass" "$ftp_server" -c "du -sm $FTPD" | awk '{print $1}')

# Calculate the remaining available space
AVAILABLE_SPACE=$((LIMIT_MB - USED_SPACE))

if [ "$AVAILABLE_SPACE" -lt 0 ]; then
    echo "Error: Space limit exceeded!"
    exit 1
else
    echo "Available space: $AVAILABLE_SPACE MB"
fi

# Send email notification
echo "$message" | mail -s "$EMAIL_SUBJECT" -a "From: $SENDER_EMAIL" -s smtp=smtp://$SMTP_SERVER:$SMTP_PORT -s smtp-use-starttls -s smtp-auth=login -s smtp-auth-user=$SMTP_USER -s smtp-auth-password=$SMTP_PASSWORD $RECIPIENT_EMAIL

echo "Cleanup and upload completed. Email notification sent."
