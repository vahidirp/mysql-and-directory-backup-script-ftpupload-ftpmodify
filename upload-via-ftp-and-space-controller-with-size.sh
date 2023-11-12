#!/bin/bash
# FTP server details
ftp_server="ftp.example.com"
ftp_user="your_username"
ftp_pass="your_password"

# FTP directory to monitor
ftp_directory="/app&web-backup/vahid.community" #change this variables to directory that you want to control
local_directory="/path/to/local/directory"  #change this variable to local directory of your backup files

# Maximum allowed space in megabytes
max_space_mb=1000 #change this variables to find files that are larger more than something 1024mb=fix1GB

# SMTP configuration for sending email
SMTP_SERVER="your_smtp_server" # Change this variables
SMTP_PORT="your_smtp_port" # Change this variables
SMTP_USER="your_smtp_user" # Change this variables
SMTP_PASSWORD="your_smtp_password" # Change this variables
RECIPIENT_EMAIL="recipient@example.com" # Change this to your email address for success or unsuccess backup progress
SENDER_EMAIL="sender@example.com" # Can same as RECIPIENT_EMAIL
EMAIL_SUBJECT="Upload To FTP" 
message="The upload and cleanup process is complete."

# Connect to the FTP server
lftp -u "$ftp_user","$ftp_pass" "$ftp_server" <<EOF
    # Change to the FTP directory
    cd "$ftp_directory"

    # Get the total size of files in the directory
    total_size=$(du -ms | awk '{print $1}')

    # Check if the total size exceeds the maximum allowed space
    if [ "$total_size" -gt "$max_space_mb" ]; then
        echo "Total space used ($total_size MB) exceeds the limit ($max_space_mb MB). Taking action..."

        # List files in the directory
        ls

        # You can implement actions here, such as deleting older files or notifying someone.

    else
        echo "Total space used ($total_size MB) is within the limit ($max_space_mb MB). No action needed."
    fi

    # Exit FTP session
    exit
EOF

# Create the remote directory if it doesn't exist
lftp -e "mkdir -p $ftp_directory; bye" -u "$ftp_user","$ftp_password" "$ftp_server"

# Upload files and directories
lftp -e "mirror -R --reverse --delete-first $local_directory $ftp_directory; bye" -u "$ftp_user","$ftp_password" "$ftp_server"

# Send email notification
echo "$message" | mail -s "$EMAIL_SUBJECT" -a "From: $SENDER_EMAIL" -s smtp=smtp://$SMTP_SERVER:$SMTP_PORT -s smtp-use-starttls -s smtp-auth=login -s smtp-auth-user=$SMTP_USER -s smtp-auth-password=$SMTP_PASSWORD $RECIPIENT_EMAIL

echo "Cleanup and upload completed. Email notification sent."
