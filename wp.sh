#!/bin/bash
## Install Wordpress on CentOS7
DIRECTORY=$(cd `dirname $0` && pwd)

turnoff_firewalld_selinux(){
    sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux
    sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
    systemctl stop firewalld
    systemctl disable firewalld
    getenforce 0
}
install_httpd(){
    yum install httpd -y
    systemctl enable httpd.service
    systemctl start httpd.service
}
install_mariadb(){
    yum install mariadb-server mariadb -y 
    systemctl start mariadb
    systemctl enable mariadb.service
}
install_php(){
    yum install php php-mysql -y 
    sudo yum install php-gd -y 
    systemctl restart httpd.service
}
config_database(){
mysql -u root <<MYSQL_SCRIPT
CREATE DATABASE wordpress;
CREATE USER wordpressuser@localhost IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON wordpress.* TO wordpressuser@localhost IDENTIFIED BY 'password';
FLUSH PRIVILEGES;
MYSQL_SCRIPT
}
install_wordpress(){
    yum install wget -y
    wget https://raw.githubusercontent.com/lacoski/wordpress/master/latest.tar.gz         
    tar xzvf latest.tar.gz
    yum install rsync -y
    rsync -r wordpress/ /var/www/html/
    mkdir -p /var/www/html/wp-content/uploads
    sudo chown -R apache:apache /var/www/html/
}
config_wordpress(){
    cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
    sed -i "s/define('DB_NAME', 'database_name_here');/define('DB_NAME', 'wordpress');/g" /var/www/html/wp-config.php
    sed -i "s/define('DB_USER', 'username_here');/define('DB_USER', 'wordpressuser');/g" /var/www/html/wp-config.php
    sed -i "s/define('DB_PASSWORD', 'password_here');/define('DB_PASSWORD', 'password');/g" /var/www/html/wp-config.php
}
turnoff_firewalld_selinux
install_httpd
install_mariadb
install_php
config_database
install_wordpress
config_wordpress