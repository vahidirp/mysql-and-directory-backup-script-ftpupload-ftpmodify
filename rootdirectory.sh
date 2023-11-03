#Domains/tabairan   tabairan
DATE=$(date +"%Y-%m-%d_%H-%M-%S")
DIR1="/home/webdata-backup/files/tabairan/"
mkdir -p "$DIR1"
zip -r $DIR1$DATE.zip /home/Domains/tabairan
find $DIR1. \*.zip -mtime +3 -delete
