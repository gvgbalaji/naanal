#!/bin/bash

# Make sure only root can run our script
if [ "$(id -u)" != "0" ]; then
   echo "You need to be 'root' dude." 1>&2
   exit 1
fi


WEBAPP=/opt/naanal/manager/webapp


cp $WEBAPP/conf/php.ini /etc/php5/apache2/
cp $WEBAPP/conf/apache2.conf /etc/apache2/
cp $WEBAPP/conf/000-default.conf /etc/apache2/sites-available/
cp -rf $WEBAPP/inc /etc/
rm -rf /var/www/html/
cp -rf $WEBAPP/html /var/www/
cp -rf $WEBAPP/images /var/www/html/
cp -rf $WEBAPP/js /var/www/html/
mkdir /var/www/html/rdp
cp -f $WEBAPP/conf/template.rdp /var/www/html/rdp/

chmod a+x -R /var/www/html/
#chmod 777 -R /opt/naanal/images
chmod -R 777  /var/www/html/rdp/

#ln -s /var/lib/glance /var/www/html/

#usermod -a -G glance www-data

#setfacl -d -m u::rwx,g::rwx,o::rwx /var/www/html/glance/images/

#cd /opt/naanal/controller/scripts && ./cpu_mem_usage.py

service apache2 restart
 
exit