#MURANO-CORE#
CONF_DIR=/opt/naanal/cloud/controller/conf
MURANO_DIR=/home/naanal/murano
mkdir /var/log/murano
touch /var/log/murano/murano.log

sudo apt-get install python-pip python-dev libmysqlclient-dev libpq-dev libxml2-dev libxslt1-dev libffi-dev

sudo pip install tox

sudo pip install --upgrade pip virtualenv setuptools pbr

mysql -u root -ppassword<<EOF
DROP DATABASE IF EXISTS murano;
CREATE DATABASE murano;
GRANT ALL PRIVILEGES ON murano.* TO 'murano'@'localhost' IDENTIFIED BY 'MURANO_DBPASS';
GRANT ALL PRIVILEGES ON murano.* TO 'murano'@'%' IDENTIFIED BY 'MURANO_DBPASS';
EOF

source $CONF_DIR/admin-openrc.sh

openstack user create --password MURANO_PASS murano
openstack role add --project service --user murano admin


cd /home/naanal
git clone -b stable/kilo git://git.openstack.org/openstack/murano
cd murano
tox -e genconfig

cd $MURANO_DIR/

cp $CONF_DIR/murano.conf $MURANO_DIR/etc/murano/murano.conf

tox -e venv -- pip install mysql-python

tox -e venv -- murano-db-manage  --config-file $MURANO_DIR/etc/murano/murano.conf upgrade


#API#
##Enter this in separate terminal##
nohup tox -e venv -- murano-api  --config-file $MURANO_DIR/etc/murano/murano.conf > /dev/null 2>&1 &

#Manage#
##Enter this in seperate terminal##
nohup tox -e venv -- murano-manage  --config-file $MURANO_DIR/etc/murano/murano.conf  import-package $MURANO_DIR/meta/io.murano > /dev/null 2>&1 &

#Engine#
##Enter this in seperate terminal##
nohup tox -e venv -- murano-engine --config-file $MURANO_DIR/etc/murano/murano.conf > /dev/null 2>&1 &


#MURANO-DASHBOARD
git clone -b stable/kilo git://git.openstack.org/openstack/murano-dashboard
git clone -b stable/kilo git://git.openstack.org/openstack/horizon

cd $MURANO_DIR/horizon
tox -e venv -- pip install -e $MURANO_DIR/murano-dashboard

cp $MURANO_DIR/murano-dashboard/muranodashboard/local/_50_murano.py $MURANO_DIR/horizon/openstack_dashboard/local/enabled/

cp $CONF_DIR/murano_local_settings.py $MURANO_DIR/horizon/openstack_dashboard/local/local_settings.py

cd $MURANO_DIR/horizon
tox -e venv -- python manage.py syncdb

tox -e venv -- python manage.py runserver controller:8800
