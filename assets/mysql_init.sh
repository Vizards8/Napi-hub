#!/bin/bash
sed -i 's/127.0.0.1/0.0.0.0/' /etc/mysql/mysql.conf.d/mysqld.cnf
chown -R mysql:mysql /var/lib/mysql /var/run/mysqld
service mysql start
mysql -u root -e "alter user 'root'@'localhost' identified with mysql_native_password by '123456';"
service mysql restart