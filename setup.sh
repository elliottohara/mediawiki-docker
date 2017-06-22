
#make sure docker-compose is set up, then just run this file

#DO NOT CHECK IN AWS KEYS! They should be set in ~/.bashrc

#export AWS_KEY = MY KEY
#export AWS_SECRET = MY SECRET

export MEDIAWIKI_DB_PASS=password
export MEDIAWIKI_SITE_SERVER=//www.bjjpedia.net
export MEDIAWIKI_SITE_NAME=BJJPEDIA
export MEDIAWIKI_DB_PASSWORD=${MEDIAWIKI_DB_PASS}
export BACKUP_LOCATION=s3://media.bjjpedia.com/BACKUP


#install docker
sudo yum install -y docker

#install docker-compose
mkdir /home/ec2-user/bin
curl -L https://github.com/docker/compose/releases/download/1.5.1/docker-compose-`uname -s`-`uname -m` > /home/ec2-user/bin/docker-compose  
chmod +x /home/ec2-user/bin/docker-compose

#fire up the containers
cd ~/mediawiki-docker
docker-compose up

export DATE=`date --date="yesterday" +"%Y/%m/%d/"`
#pull down the backup file
docker run \
--env aws_key=${AWS_KEY} \
--env aws_secret=${AWS_SECRET} \
--env cmd=sync-s3-to-local \
--env SRC_S3=${BACKUP_LOCATION}/${DATE}backup.zip \
-v /home/ec2-user/backups:/opt/dest \
garland/docker-s3cmd


unzip /home/ec2-user/backups/backup.zip

cat /home/ec2-user/backups/backup/backup.sql | docker exec -i mediawikidocker_db_1 /usr/bin/mysql \
-u root \
--password=${MEDIAWIKI_DB_PASS} mediawiki
