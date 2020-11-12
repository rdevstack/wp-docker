# Containarizing Wordpress 

The Project explains the steps top create a docker image from wordpress source file

1. Make a Project Directory
```
mkdir wp-docker && cd wp-docker
```
2. Download Wordpress Source Code from Official Website

```
#In MacOS
$ curl -O https://wordpress.org/latest.tar.gz

# In Linux
$ wget https://wordpress.org/latest.tar.gz
```

3. Extract the files 
```
$ tar xvzf latest.tar.gz && rm latest.tar.gz
```

4. Create entrypoint file "entrypoint.sh"
```
#! /bin/bash
#rename wp-config file
mv /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
#Substitute string with env varibale globally
sed -i "s/database_name_here/$DB_NAME/g" /var/www/html/wp-config.php
sed -i "s/username_here/$DB_USER/g" /var/www/html/wp-config.php
sed -i "s/password_here/$DB_PASSWORD/g" /var/www/html/wp-config.php
sed -i "s/localhost/$DB_HOST/g" /var/www/html/wp-config.php

#Start Apache without terminating
apachectl -D FOREGROUND
```
5. Create Docker File "Dockerfile"
```
FROM ubuntu:18.04
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y apache2 libapache2-mod-php php-mysql
RUN rm /var/www/html/index.html
COPY wordpress /var/www/html 
COPY entrypoint.sh /entrypoint.sh 
RUN chmod 755 /entrypoint.sh
CMD /entrypoint.sh
```
6. Build Docker Image
```
docker image build -t <tagname> .
docker image build -t wordpress:0.0.1 .
```
7. if we want to send this image to docker hub, we need to retag image 
```
docker image tag SOURCE_IMAGE:TAG YOURREPO/TARGET_IMAGE:TAG
$ docker image tag wordpress:0.0.1 devopsdoor/wordpress:0.0.1
docker image push YOURDOCKERREPO/YOUR_IMAGE:TAG
$ docker image push devopsdoor/mywebserver:0.0.1
```

8. Create/pull Database (MySQL) Container
```
#Pull the latest mysql & wordpress images from dockerhub
docker pull devopsdoor/mysql:5.7
docker pull devopsdoor/wordpress:0.0.2
#List all the images downloaded and confrim mysql image is there
docker images -a
#Run Mysql passing the environment variables
docker run -d -e MYSQL_ROOT_PASSWORD=DEVOPS1 -e MYSQL_DATABASE=wpdb -e MYSQL_USER=wpuser -e MYSQL_PASSWORD=DEVOPS12345 devopsdoor/mysql:5.7
#make sure container is running
docker ps
```

9. Run Wordpress Container from previously created image "wordpress:0.0.1" in Step 6 and env varibales from step 8. DB_HOST IP can be obtained by doing docker inspect on mysql container 
```

docker run -d -p 80:80 -e DB_NAME=wpdb -e DB_USER=wpuser -e DB_PASSWORD=DEVOPS12345 -e DB_HOST=172.17.0.2 devopsdoor/wordpress:0.0.1
```
