#!/bin/bash

# Make sure only root can run our script
if [ "$(id -u)" != "0" ]; then
   echo "You need to be 'root' dude." 1>&2
   exit 1
fi

apt-get update

# bridge stuff
apt-get install vim ntp dos2unix git openssh-server -y

apt-get install -y python-keystoneclient python-glanceclient pyhton-novaclient python-neutronclient python-ceilometerclient python-cinderclient 

#apt-get install -y openstack-dashboard libapache2-mod-php5 php5-mysql
apt-get install -y openstack-dashboard 

apt-get install -y openvpn

exit

