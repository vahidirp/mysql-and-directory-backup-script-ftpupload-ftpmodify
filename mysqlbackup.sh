#!/bin/bash

DB_USER="administrator-username or root" #change this variables
DB_PASS="administrator-password or root password" #change this variables
DB_1="yourDB_Name" #change this variables
DATE=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_DIR1="your directory that you want save backup/$DB_1" #change this variables for example : BACKUP_DIR1="/home/mysqlbackup/$DB_1"
mkdir -p "$BACKUP_DIR1"
mysqldump --user=$DB_USER --password=$DB_PASS $DB_1 > $BACKUP_DIR1/$DB_1-$DATE.sql
gzip $BACKUP_DIR1/$DB_1-$DATE.sql
