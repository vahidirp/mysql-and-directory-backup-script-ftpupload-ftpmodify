# bash-script-backup
### backup dumped mysql database  &amp; backup your app/web root directory with bash script

### Main features

 - Backup Application or Web Root directories 
 - Backup MySQL/MariaDB databases, dump and zip
 - Backup multiple MariaDB/MySQL docker containers
 - Space Control for Backup host from FTP
 - Encrypts backup file using GPG
 - Send a notification to email
   
### Change variables on script files

### Before run :
```
chmod +x filename.sh
```
### Run script : 
```
sudo bash backup.sh
```

You can all same templates of variables for do more backup of your database or app/web root directory

You can use cronjob to run auto these scripts

### Requirements

- tar
- gzip 
- zip & unzip
- bzip2


### Change log

**V1.6**
- add ftp space control
- fix bugs
- 
**V1.8**
- backup multiple mysql/mariadb backup
- email receipt added
- local space control added
- fix bug and errors

### Task for future

- [ ] Fix errors & bugs


