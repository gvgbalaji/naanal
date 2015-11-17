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
WEBAPP=/opt/naanal/webapp

#Database updates#

#mysql -u root --password=$mysql_passwd <<EOF

#EOF

#Webapp Files#
 
#cp $WEBAPP/conf/php.ini /etc/php5/apache2/
#cp $WEBAPP/conf/apache2.conf /etc/apache2/
#cp $WEBAPP/conf/000-default.conf /etc/apache2/sites-available/

rm -rf /etc/inc
cp -rf $WEBAPP/inc /etc/
rm -rf /var/www/html/
cp -rf $WEBAPP/html /var/www/
cp -rf $WEBAPP/images /var/www/html/
cp -rf $WEBAPP/js /var/www/html/
mkdir /var/www/html/rdp
cp -f $WEBAPP/conf/template.rdp /var/www/html/rdp/

#Permissions#

chmod a+x -R /var/www/html/
chmod 777 -R /opt/naanal/images

ln -s /var/lib/glance /var/www/html/

usermod -a -G glance www-data

setfacl -d -m u::rwx,g::rwx,o::rwx /var/www/html/glance/images/

service apache2 restart
 
#Non WEBAPP Files#
cp opt/naanal/controller/conf/rc.local /etc/
 

exit