#!/bin/bash

# Set the file to be encrypted
file_to_encrypt="file.txt" #change this variable to your file that want to encrypt

# Set the static passphrase
passphrase="YourStaticPassphraseHere" #change this variable (it is static) can contains Complexity Length Unpredictability Unique Memorability example: "P@ssw0rd$ecure4Me"

# Recipient's email address
recipient_email="recipient@example.com" #change this variable with your administrator or monitoring email.

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
    echo "Sending encrypted file ($output_file) to $recipient_email..."
    echo "Please find the encrypted file attached." | mail -s "Encrypted File" -a "$output_file" "$recipient_email"
    echo "Email sent successfully."
else
    echo "Encryption failed."
fi

