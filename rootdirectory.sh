#Name of your App/Web project
DATE=$(date +"%Y-%m-%d_%H-%M-%S")
DIR1="directory to save backup/app or domain or web name" #change this variables, this for save backup file for example: DIR1="/home/app&web-backup/vahid.community/"
mkdir -p "$DIR1"
zip -r $DIR1$DATE.zip /directory/to/app/or/web #change this variables, this for zip and backup of your app or web root directory. example: /home/app&web/vahid.community
