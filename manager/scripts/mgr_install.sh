#!/bin/bash

# Make sure only root can run our script
if [ "$(id -u)" != "0" ]; then
   echo "You need to be 'root' dude." 1>&2
   exit 1
fi

apt-get update


apt-get install -y  vim ntp dos2unix git openssh-server sshpass

apt-get install -y python-keystoneclient python-glanceclient python-novaclient python-neutronclient python-ceilometerclient python-cinderclient 

apt-get install -y libapache2-mod-php5 php5-mysql php5-dev pkg-config php-pear mysql-server

apt-get install -y openstack-dashboard 

apt-get install -y openvpn

apt-get install -y python-zmq

wget http://download.zeromq.org/zeromq-4.0.5.tar.gz 
tar -xvzf zeromq-4.0.5.tar.gz
cd zeromq-4.0.5
./configure
make
sudo make install
sudo ldconfig

pecl install zmq-beta

cd /opt/naanal/manager/webapp/scripts && ./webapp_deploy.sh

exit

