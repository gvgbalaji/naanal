#!/bin/bash

# Make sure only root can run our script
if [ "$(id -u)" != "0" ]; then
   echo "You need to be 'root' dude." 1>&2
   exit 1
fi

# grab our IP
#read -p "Enter the device name for this rig's NIC (eth0, etc.) : " ext_nic
#ext_nic=em1
ext_nic=br-wan
ext_ip=$(/sbin/ifconfig $ext_nic| sed -n 's/.*inet *addr:\([0-9\.]*\).*/\1/p')
password=password
mysql_passwd=password
email=contact@naanalnetworks.com
region=regionOne
token=token
WEBAPP=/opt/naanal/webapp/


mysql -u root --password=$mysql_passwd <<EOF
DROP DATABASE IF EXISTS naanal;
CREATE DATABASE naanal ;

CREATE TABLE naanal.cpu_mem_usage(  updated_dt datetime DEFAULT NULL,  cpu_percent int(11) DEFAULT NULL,  mem_percent int(11) DEFAULT NULL) ENGINE=InnoDB DEFAULT CHARSET=latin1 ;


CREATE TABLE naanal.user (
  username char(30) NOT NULL,
  password char(100) NOT NULL,
  tenant char(50) NOT NULL,
  instance char(50) DEFAULT NULL,
  admin_flag tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (username)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE naanal.tenant_ip (  id int(11) NOT NULL AUTO_INCREMENT,  tenant char(30) DEFAULT NULL,  app_nm char(30) DEFAULT NULL,  ip_addr char(30) DEFAULT NULL,  PRIMARY KEY (id)) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;


insert into naanal.user values('admin',md5('password'),'Administrator','',1);
insert into naanal.tenant_ip(tenant,app_nm,ip_addr) values('Administrator','squid','$ext_ip');

CREATE TABLE naanal.custom_setting (
  id int(11) NOT NULL AUTO_INCREMENT,
  instance char(50) NOT NULL DEFAULT '',
  autostart tinyint(1) DEFAULT NULL,
  PRIMARY KEY (id,instance)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;

grant all privileges on *.* to 'root'@'%' identified by 'password';
grant all privileges on *.* to 'root'@'localhost' identified by 'password';


EOF

cp $WEBAPP/conf/php.ini /etc/php5/apache2/
cp $WEBAPP/conf/apache2.conf /etc/apache2/
cp $WEBAPP/conf/000-default.conf /etc/apache2/sites-available/
cp -rf $WEBAPP/inc /etc/
rm -rf /var/www/html/
cp -rf $WEBAPP/html /var/www/
cp -rf $WEBAPP/images /var/www/html/
cp -rf $WEBAPP/js /var/www/html/

chmod a+x -R /var/www/html/
chmod 777 -R /opt/naanal/images

ln -s /var/lib/glance /var/www/html/

usermod -a -G glance www-data

setfacl -d -m u::rwx,g::rwx,o::rwx /var/www/html/glance/images/

./cpu_mem_usage.py

service apache2 restart
 
exit