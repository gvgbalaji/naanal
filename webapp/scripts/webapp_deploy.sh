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


CREATE TABLE naanal.user (  username varchar(20) DEFAULT NULL,  password varchar(200) DEFAULT NULL,  tenant char(50) DEFAULT NULL) ENGINE=InnoDB DEFAULT CHARSET=latin1;


CREATE TABLE naanal.tenant_ip (  id int(11) NOT NULL AUTO_INCREMENT,  tenant char(30) DEFAULT NULL,  app_nm char(30) DEFAULT NULL,  ip_addr char(30) DEFAULT NULL,  PRIMARY KEY (id)) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;


insert into naanal.user values('admin',md5('ADMIN'),'admin');
insert into naanal.tenant_ip(tenant,app_nm,ip_addr) values('admin','squid','$ext_ip');

grant ALL  on *.*  TO 'root'@'%' IDENTIFIED BY  'password';

EOF

cp $WEBAPP/conf/php.ini /etc/php5/apache2/
cp $WEBAPP/conf/apache2.conf /etc/apache2/
cp $WEBAPP/conf/000-default.conf /etc/apache2/sites-available/
mkdir -p /etc/inc
cp -rf $WEBAPP/inc/* /etc/inc/
rm -rf /var/www/html/
cp -rf $WEBAPP/html /var/www/
cp -rf $WEBAPP/images /var/www/html/
cp -rf $WEBAPP/js /var/www/html/

service apache2 restart
 
exit

