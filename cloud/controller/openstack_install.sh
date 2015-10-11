start_time=`date +%s`
apt-get install -y unzip expect curl git
apt-get -y install  ntp 
apt-get -y install ubuntu-cloud-keyring
echo "deb http://ubuntu-cloud.archive.canonical.com/ubuntu" \
"trusty-updates/kilo main" > /etc/apt/sources.list.d/cloudarchive-kilo.list
apt-get update && apt-get -y upgrade

export DEBIAN_FRONTEND="noninteractive"

debconf-set-selections <<< "mariadb-server mariadb-server/root_password password "
debconf-set-selections <<< "mariadb-server mariadb-server/root_password_again password "

apt-get install -y mariadb-server python-mysqldb


apt-get install -y rabbitmq-server

echo "manual" > /etc/init/keystone.override
apt-get install -y keystone python-openstackclient apache2 libapache2-mod-wsgi memcached python-memcache

apt-get install -y glance python-glanceclient

apt-get install -y nova-api nova-cert nova-conductor nova-consoleauth nova-novncproxy nova-scheduler python-novaclient nova-compute sysfsutils

apt-get install -y neutron-server neutron-plugin-ml2 python-neutronclient  

apt-get install -y neutron-plugin-ml2 neutron-plugin-openvswitch neutron-plugin-openvswitch-agent neutron-l3-agent neutron-dhcp-agent neutron-metadata-agent

apt-get install -y openstack-dashboard

apt-get remove -y --purge openstack-dashboard-ubuntu-theme

apt-get install -y ceilometer-api ceilometer-collector ceilometer-agent-central ceilometer-agent-notification ceilometer-alarm-evaluator ceilometer-alarm-notifier python-ceilometerclient ceilometer-agent-compute

apt-get install -y heat-api heat-api-cfn heat-engine python-heatclient

apt-get install -y cinder-api cinder-scheduler python-cinderclient cinder-volume python-mysqldb qemu lvm2 tcm 



mkdir -p /var/www/cgi-bin/keystone

#curl http://git.openstack.org/cgit/openstack/keystone/plain/httpd/keystone.py?h=stable/kilo | tee /var/www/cgi-bin/keystone/main /var/www/cgi-bin/keystone/admin


mkdir /tmp/images
wget -P /tmp/images http://download.cirros-cloud.net/0.3.4/cirros-0.3.4-x86_64-disk.img



end_time=`date +%s`
tot_time=$(($end_time-$start_time))
echo Total Time Taken $tot_time seconds

echo " RUN /opt/naanal/controller/openstack_script.sh to finsish Installation"

