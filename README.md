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

**V1.8**
- backup multiple mysql/mariadb backup
- email receipt added
- local space control added
- fix bug and errors

**V2.0**
- add custom smtp identity feature 
- fix bugs and syntax error
- optimizing
### Task for future

- [ ] Fix errors & bugs
- [ ] Use GPG Encryption in releases to encrypt
### Donate if you like :)
- [USD T] TYJcqjinzdkyC4KozyqD8LqeJ2VFv3Zg8X1

- [BTC] bc1qe4dweeppgwjhfeehxa5d0nyfp6qe8gyruyhdtp

