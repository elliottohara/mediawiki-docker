docker exec mediawikidocker_db_1 /usr/bin/mysqldump \
-u root \
--password=password  \
mediawiki > /home/ec2-user/backups/backup.sql


zip /home/ec2-user/backups/backup.zip /home/ec2-user/backups/backup.sql

rm  /home/ec2-user/backups/backup.sql

docker run \
--env aws_key=MY KEY \
--env aws_secret=MY SECRET \
--env cmd=sync-local-to-s3 \
--env DEST_S3=s3://media.bjjpedia.com/BACKUP/`date '+%Y/%m/%d/'` \
-v /home/ec2-user/backups:/opt/src \
garland/docker-s3cmd


