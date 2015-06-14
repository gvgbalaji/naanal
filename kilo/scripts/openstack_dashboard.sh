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
ext_ip=192.168.1.231
password=password
mysql_passwd=password
email=contact@naanalnetworks.com
region=regionOne
token=token
#WEBAPP=/opt/naanal/webapp/

apt-get -y remove --purge openstack-dashboard-ubuntu-theme
cp /opt/naanal/kilo/dashboard/local_settings.py  /etc/openstack-dashboard/local_settings.py
cp /opt/naanal/kilo/dashboard/favicon.ico /usr/share/openstack-dashboard/static/dashboard/img/
cp /opt/naanal/kilo/dashboard/logo-splash.png /usr/share/openstack-dashboard/static/dashboard/img/
cp /opt/naanal/kilo/dashboard/logo.png /usr/share/openstack-dashboard/static/dashboard/img/
service apache2 restart
 
exit

