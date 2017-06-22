#run this first 
sudo yum install -y docker
sudo service docker start
sudo usermod -a -G docker ec2-user

#make sure to log off before trying to run docker
