#!/bin/bash
if [ ! -f /var/www/sites/default/settings.php ]; then
	# Start mysql
	# /usr/bin/mysqld_safe &
	sleep 10s
	# Generate random passwords
	# DRUPAL_DB="drupal"
	# MYSQL_PASSWORD=`pwgen -c -n -1 12`
	# DRUPAL_PASSWORD=`pwgen -c -n -1 12`
	# This is so the passwords show up in logs.
	# echo mysql root password: $MYSQL_PASSWORD
	# echo drupal password: $DRUPAL_PASSWORD
	# echo $MYSQL_PASSWORD > /mysql-root-pw.txt
	# echo $DRUPAL_PASSWORD > /drupal-db-pw.txt
	# mysqladmin -u root password $MYSQL_PASSWORD
	mysql -h ${DATABASE_HOST} -P ${DATABASE_PORT} -u ${DATABASE_USER} -p${DATABASE_PASSWORD} -e "CREATE DATABASE IF NOT EXISTS ${DATABASE_NAME}; GRANT ALL PRIVILEGES ON drupal.* TO '${DATABASE_USER}' IDENTIFIED BY '$DATABASE_PASSWORD'; FLUSH PRIVILEGES;"
	sed -i 's/AllowOverride None/AllowOverride All/' /etc/apache2/sites-available/default
	a2enmod rewrite vhost_alias
	cd /var/www/
	drush site-install nwcaa -y --account-name=admin --account-pass=admin --db-url="mysqli://${DATABASE_USER}:${DATABASE_PASSWORD}@${DATABASE_HOST}:${DATABASE_PORT}/${DATABASE_NAME}" --debug
	# killall mysqld
	sleep 10s
fi
supervisord -n
