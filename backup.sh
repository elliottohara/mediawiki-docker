docker exec mediawikidocker_db_1 /usr/bin/mysqldump \
-u root \
--password=password  \
mediawiki > /home/ec2-user/backups/backup.sql


zip /home/ec2-user/backups/backup.zip /home/ec2-user/backups/backup.sql

rm  /home/ec2-user/backups/backup.sql

docker run \
--env aws_key=AKIAIBP3FR633F43H5XA \
--env aws_secret=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 \
--env cmd=sync-local-to-s3 \
--env DEST_S3=s3://media.bjjpedia.com/BACKUP/`date '+%Y/%m/%d/'` \
-v /home/ec2-user/backups:/opt/src \
garland/docker-s3cmd


