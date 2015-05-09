#!/bin/bash

# Make sure only root can run our script
if [ "$(id -u)" != "0" ]; then
   echo "You need to be 'root' dude." 1>&2
   exit 1
fi

apt-get update

# bridge stuff
apt-get install vlan qemu-kvm libvirt-bin ubuntu-vm-builder bridge-utils cpu-checker -y

# install time server
apt-get install ntp -y

apt-get install -y rabbitmq-server

apt-get install -y mysql-server python-mysqldb

apt-get install -y keystone

apt-get install -y glance

apt-get install -y nova-api nova-cert nova-conductor nova-consoleauth nova-novncproxy nova-scheduler python-novaclient nova-compute nova-console

apt-get install -y neutron-server neutron-plugin-openvswitch neutron-plugin-openvswitch-agent neutron-common neutron-dhcp-agent neutron-l3-agent neutron-metadata-agent openvswitch-switch

apt-get install -y openstack-dashboard libapache2-mod-php5 php5-mysql

apt-get install -y ceilometer-api ceilometer-collector ceilometer-agent-central ceilometer-agent-notification ceilometer-alarm-evaluator ceilometer-alarm-notifier python-ceilometerclient ceilometer-agent-compute

apt-get install -y cinder-api cinder-scheduler lvm2 tcm  cinder-volume

apt-get install -y upower dos2unix git

apt-get install -y python-zmq

exit

