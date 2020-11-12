FROM ubuntu:18.04
#Zero interaction while installing or upgrading the system via apt
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y apache2 libapache2-mod-php php-mysql
RUN rm /var/www/html/index.html
COPY wordpress /var/www/html 
COPY entrypoint.sh /entrypoint.sh 
RUN chmod 755 /entrypoint.sh
CMD /entrypoint.sh