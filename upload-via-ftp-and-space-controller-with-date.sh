#!/bin/bash
# FTP server details
ftp_server="ftp.example.com" 
ftp_user="your_username"
ftp_pass="your_password"

# FTP directory to clean
ftp_directory="/app&web/vahid.community" #change this variable to directory on ftp that you want to upload and control
local_directory="/path/to/local/directory"  #change this variable to local directory of your backup files
# Define the maximum age of files to keep in days
DELDATE=$(date -d "-5 days" +"%d-%m-%Y")  #change this variables for delete files older that some days for example for delete more than 4 days : DELDATE=$(date -d "-4 days" +"%d-%m-%Y")

# SMTP configuration for sending email
SMTP_SERVER="your_smtp_server" # Change this variables
SMTP_PORT="your_smtp_port" # Change this variables
SMTP_USER="your_smtp_user" # Change this variables
SMTP_PASSWORD="your_smtp_password" # Change this variables
RECIPIENT_EMAIL="recipient@example.com" # Change this to your email address for success or unsuccess backup progress
SENDER_EMAIL="sender@example.com" # Can same as RECIPIENT_EMAIL
EMAIL_SUBJECT="Upload To FTP" 
message="The upload and cleanup process is complete."

# Cleanup LOCAL DIRBACKUP DIR in FTP Server
ncftp -u "$ftp_user" -p "$ftp_pass" "$ftp_server" <<EOF
cd "$ftp_directory"
cd "$DELDATE"
rm *
rmdir "$DELDATE"
quit
EOF

# Start Upload Data
ncftpput -R -v -u $ftp_user -p $ftp_pass $ftp_server $ftp_directory $local_directory

# Send email notification
echo "$message" | mail -s "$EMAIL_SUBJECT" -a "From: $SENDER_EMAIL" -s smtp=smtp://$SMTP_SERVER:$SMTP_PORT -s smtp-use-starttls -s smtp-auth=login -s smtp-auth-user=$SMTP_USER -s smtp-auth-password=$SMTP_PASSWORD $RECIPIENT_EMAIL

echo "Cleanup and upload completed. Email notification sent."
