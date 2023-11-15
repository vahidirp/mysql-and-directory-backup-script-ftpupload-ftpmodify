#!/bin/bash
DATE=$(date +"%Y-%m-%d_%H-%M-%S")
DB_NAME_1="your_database_name"
DB_NAME_2="your_database_name"
# Set your MariaDB container name
DB_CONTAINER_1="your_mariadb_container_name"
DB_CONTAINER_2="your_mariadb_container_name"
# Set the backup directory
DB_DIR_1="/path/to/backup/directory"
DB_DIR_2="/path/to/backup/directory"
# Set DB's Username & Password for identity
DB1_User="your_database1_username"
DB1_Password="your_database1_password"
DB2_User="your_database2_username"
DB2_Password="your_database2_password"

mkdir -p "$DB_DIR_1"
mkdir -p "$DB_DIR_2"
# Docker exec command to run mysqldump inside the container and compress the backup
 docker exec -i ${DB_CONTAINER_1} mysqldump --user=${DB1_User} --password=${DB1_Password} ${DB_Name_1} | gzip > ${DB_DIR_1}/${DB_Name_1}-${DATE}.gz
 docker exec -i ${DB_CONTAINER_2} mysqldump --user=${DB2_User} --password=${DB2_Password} ${DB_Name_2} | gzip > ${DB_DIR_2}/${DB_Name_2}-${DATE}.gz
