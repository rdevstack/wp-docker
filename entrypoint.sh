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