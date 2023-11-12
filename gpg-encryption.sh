#!/bin/bash

# Set the file to be encrypted
file_to_encrypt="file.txt" #change this variable to your file that want to encrypt

# Set the static passphrase
passphrase="YourStaticPassphraseHere" #change this variable (it is static) can contains Complexity Length Unpredictability Unique Memorability example: "P@ssw0rd$ecure4Me"

# SMTP configuration for sending email
SMTP_SERVER="your_smtp_server" # Change this variables
SMTP_PORT="your_smtp_port" # Change this variables
SMTP_USER="your_smtp_user" # Change this variables
SMTP_PASSWORD="your_smtp_password" # Change this variables
RECIPIENT_EMAIL="recipient@example.com" # Change this to your email address for success or unsuccess backup progress
SENDER_EMAIL="sender@example.com" # Can same as RECIPIENT_EMAIL
EMAIL_SUBJECT="GPG Encryption" 


# Extract the base name of the file (without the path)
base_name=$(basename "$file_to_encrypt")

# Define the output file name with the ".gpg" extension
output_file="${base_name}.gpg"

# Encrypt the file using GPG with the static passphrase
gpg --batch --yes --passphrase "$passphrase" --output "$output_file" --symmetric "$file_to_encrypt"

# Check the exit status to determine if encryption was successful
if [ $? -eq 0 ]; then
    echo "File encrypted successfully."

    # Send the encrypted file as an email attachment
    echo "Sending encrypted file ($output_file) to $RECIPIENT_EMAIL..."
    echo "Please find the encrypted file attached." | mail -s "$EMAIL_SUBJECT_PASS" -a "From: $SENDER_EMAIL" -a "$output_file" -s smtp=smtp://$SMTP_SERVER:$SMTP_PORT -s smtp-use-starttls -s smtp-auth=login -s smtp-auth-user=$SMTP_USER -s smtp-auth-password=$SMTP_PASSWORD $RECIPIENT_EMAIL
    echo "Email sent successfully."
else
    echo "Encryption failed."
fi

