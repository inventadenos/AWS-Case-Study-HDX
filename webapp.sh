#!/bin/bash

#This script enables the setup of our web application
amazon-linux-extras enable php8.0 -y
yum clean metadata
yum install php-cli php-pdo php-fpm php-mysqlnd -y
yum install httpd -y
systemctl start httpd
systemctl enable httpd
cd /var/www/html/
wget http://wordpress.org/latest.tar.gz
tar -zvxf latest.tar.gz
cp -r wordpress/* /var/www/html
rm -rf latest.tar.gz
rm -rf wordpress
chmod -R 755 wp-content/
chown -R apache:apache wp-content/
echo "Launch the instance with the public IP and hit Let’s go"
echo "DB name = your initial database name"
echo "Username = your master username (when you created your Database)"
echo "Password = your master password (when you created the Database)"
echo "LocalHost = Your Database Endpoint"
echo "Hit Submit"
echo "Copy the code in the new window"
echo "vi wp-config.php and paste the copied code, save and close"
rm -rf wp-config-sample.php
echo "Go back to your word press site and click Run the installation” 