#!/bin/bash
# FTP server details
ftp_server="ftp.example.com" 
ftp_user="your_username"
ftp_pass="your_password"

# FTP directory to clean
ftp_directory="/app&web/vahid.community" #change this variable to directory on ftp that you want to control

# Define the maximum age of files to keep in days
max_age_days=30 #change this variables for delete files older that some days for example for delete more than 4 days : max_age_days=4

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
