start_time=`date +%s`

ops_ip=192.168.1.230
ops_net=192.168.1.0
ops_mask=255.255.255.0
wan_port=em1
wan_cidr=192.168.1.0/24
wan_gateway=192.168.1.1
wan_ip_start=192.168.1.240
wan_ip_end=192.168.1.254
lan_gateway=10.0.0.1
lan_cidr=10.0.0.0/24
mysql_password=password
#cinder_volume=sdb
home_dir=/opt/naanal/cloud/controller/


echo "Basic Networking..."


cp $home_dir/conf/interfaces /etc/network/interfaces
sed -i -e "s/EXT_IP/$ops_ip/" -e "s/WAN_PORT/$wan_port/" -e "s/MASK/$ops_mask/" -e "s/GW_IP/$wan_gateway/" /etc/network/interfaces

ovs-vsctl add-br br-wan 
ovs-vsctl add-br br-lan 
ovs-vsctl add-port br-wan $wan_port && ifconfig $wan_port 0.0.0.0 && ifconfig br-wan $ops_ip


#------------------------------------------------------------------------#
cp $home_dir/conf/main /var/www/cgi-bin/keystone/main
cp $home_dir/conf/admin /var/www/cgi-bin/keystone/admin


## HOSTS ##
cp /etc/hosts /etc/hosts.bkp
echo $ops_ip	controller >> /etc/hosts


#------------------------------------------------------------------------#

## NTP ##
#apt-get -y install  ntp 
cp $home_dir/conf/ntp.conf /etc/ntp.conf
sed -i -e "s/NETWORK/$ops_net/" -e "s/MASK/$ops_mask/" /etc/ntp.conf
service ntp restart
ntpq -p

#------------------------------------------------------------------------#

## Openstack Repository ##
#apt-get -y install ubuntu-cloud-keyring
echo "deb http://ubuntu-cloud.archive.canonical.com/ubuntu" \
"trusty-updates/kilo main" > /etc/apt/sources.list.d/cloudarchive-kilo.list
#apt-get update && #apt-get -y upgrade


#------------------------------------------------------------------------#

## Mysql ##

echo "Installing Mysql..."

#export DEBIAN_FRONTEND="noninteractive"

#debconf-set-selections <<< "mariadb-server mariadb-server/root_password password "
#debconf-set-selections <<< "mariadb-server mariadb-server/root_password_again password "

#apt-get install -y mariadb-server python-mysqldb

cp $home_dir/conf/mysqld_openstack.cnf /etc/mysql/conf.d/mysqld_openstack.cnf

#cp /opt/naanal/controller/conf/my.cnf /etc/mysql/my.cnf

sed -i "s/^bind-address/#bind-address/" /etc/mysql/my.cnf

service mysql restart


echo "Securing MYSQL..."

$home_dir/expect/mysql_expect $mysql_password


service mysql restart

#service mysql status | grep Active | awk '{print "Mysql Status: " $2}'
 
mysql -u root --password=$mysql_password<<EOT
DROP DATABASE IF EXISTS keystone;
DROP DATABASE IF EXISTS glance;
DROP DATABASE IF EXISTS nova;
DROP DATABASE IF EXISTS neutron;
DROP DATABASE IF EXISTS ceilometer;
DROP DATABASE IF EXISTS heat;
DROP DATABASE IF EXISTS cinder;
EOT

echo "Mysql Finished"
 
#------------------------------------------------------------------------#

## Rabbitmq ##
echo "Installing Rabbitmq..."

#apt-get install -y rabbitmq-server
rabbitmqctl add_user openstack RABBIT_PASS
rabbitmqctl set_permissions openstack ".*" ".*" ".*"


echo "Rabbitmq Finished"

#------------------------------------------------------------------------#


## Keystone ##
echo "Installing Keystone..."

mysql -u root --password=$mysql_password<<EOT
CREATE DATABASE keystone;
GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'localhost' IDENTIFIED BY 'KEYSTONE_DBPASS';
GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'%' IDENTIFIED BY 'KEYSTONE_DBPASS';
EOT

#echo "manual" > /etc/init/keystone.override
#apt-get install -y keystone python-openstackclient apache2 libapache2-mod-wsgi memcached python-memcache


echo "Configuring Keystone..."
cp $home_dir/conf/keystone.conf /etc/keystone/keystone.conf
su -s /bin/sh -c "keystone-manage db_sync" keystone

#### Configuring Apache Server ####

echo "Configuring Apache Server..."
cp $home_dir/conf/apache2.conf /etc/apache2/apache2.conf
cp $home_dir/conf/wsgi-keystone.conf /etc/apache2/sites-available/wsgi-keystone.conf 
ln -s /etc/apache2/sites-available/wsgi-keystone.conf /etc/apache2/sites-enabled
#mkdir -p /var/www/cgi-bin/keystone

#curl http://git.openstack.org/cgit/openstack/keystone/plain/httpd/keystone.py?h=stable/kilo | tee /var/www/cgi-bin/keystone/main /var/www/cgi-bin/keystone/admin

chown -R keystone:keystone /var/www/cgi-bin/keystone
chmod 755 /var/www/cgi-bin/keystone/*

service keystone stop
sleep 2
service apache2 restart

#service apache2 status | grep Active | awk '{print "Apache Status: " $2}'

mv /var/lib/keystone/keystone.db /var/lib/keystone/keystone.db.bkp

service keystone restart

echo "Configuring Apache server Done"

echo "Creating Keystone Service and Endpoint..."

export OS_TOKEN=ADMIN
export OS_URL=http://controller:35357/v2.0



openstack service create --name keystone --description "OpenStack Identity" identity
openstack endpoint create --publicurl http://controller:5000/v2.0 --internalurl http://controller:5000/v2.0 --adminurl http://controller:35357/v2.0 --region RegionOne identity

openstack project create --description "Admin Project" admin
openstack user create --password=ADMIN admin
openstack role create admin
openstack role add --project admin --user admin admin
openstack project create --description "Service Project" service

cp $home_dir/conf/keystone-paste.ini /etc/keystone/keystone-paste.ini
unset OS_TOKEN OS_URL

source $home_dir/conf/admin-openrc.sh

openstack token issue

echo " Keystone Finished "


#------------------------------------------------------------------------#


## GLANCE ##
echo "Installing Glance...."

mysql -u root --password=$mysql_password<<EOT
CREATE DATABASE glance;
GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'localhost' IDENTIFIED BY 'GLANCE_DBPASS';
GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'%' IDENTIFIED BY 'GLANCE_DBPASS';
EOT

openstack user create --password=GLANCE_PASS glance
openstack role add --project service --user glance admin
openstack service create --name glance --description "OpenStack Image service" image
openstack endpoint create --publicurl http://controller:9292 --internalurl http://controller:9292 --adminurl http://controller:9292 --region RegionOne image


#apt-get install -y glance python-glanceclient

echo "Configuring glance...."

cp $home_dir/conf/glance-api.conf /etc/glance/glance-api.conf
cp $home_dir/conf/glance-registry.conf /etc/glance/glance-registry.conf

su -s /bin/sh -c "glance-manage db_sync" glance
service glance-registry restart
service glance-api restart

mv /var/lib/glance/glance.sqlite /var/lib/glance/glance.sqlite.bkp

#mkdir /tmp/images
#wget -P /tmp/images http://download.cirros-cloud.net/0.3.4/cirros-0.3.4-x86_64-disk.img

#chmod -R a+x /tmp/images/

#glance image-create --name cirros --file /tmp/images/cirros-0.3.4-x86_64-disk.img --disk-format qcow2 --container-format bare --visibility public

sleep 2

glance image-list
#rm -r /tmp/images

echo "Glance Finished"

#------------------------------------------------------------------------#


## Compute ##
echo "Installing Compute..."

mysql -u root -ppassword<<EOT
CREATE DATABASE nova;
GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'localhost' IDENTIFIED BY 'NOVA_DBPASS';
GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'%' IDENTIFIED BY 'NOVA_DBPASS';
EOT

openstack user create --password=NOVA_PASS nova
openstack role add --project service --user nova admin
openstack service create --name nova --description "OpenStack Compute" compute
openstack endpoint create --publicurl http://controller:8774/v2/%\(tenant_id\)s --internalurl http://controller:8774/v2/%\(tenant_id\)s --adminurl http://controller:8774/v2/%\(tenant_id\)s --region RegionOne compute

#apt-get install -y nova-api nova-cert nova-conductor nova-consoleauth nova-novncproxy nova-scheduler python-novaclient nova-compute sysfsutils

echo "Configuring Compute..."
cp $home_dir/conf/nova.conf /etc/nova/nova.conf

sed -i "s/EXT_IP/$ops_ip/g" /etc/nova/nova.conf


cp $home_dir/conf/nova-compute.conf /etc/nova/nova-compute.conf

su -s /bin/sh -c "nova-manage db sync" nova



service nova-api restart
service nova-cert restart
service nova-consoleauth restart
service nova-scheduler restart
service nova-conductor restart
service nova-novncproxy restart
service nova-compute restart

mv /var/lib/nova/nova.sqlite  /var/lib/nova/nova.sqlite.bkp

sleep 6
nova service-list

echo "Nova Finished"


#------------------------------------------------------------------------#


## Neutron ##
echo "Installing Controller-Neutron..."
mysql -u root -ppassword<<EOT
CREATE DATABASE neutron;
GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'localhost' IDENTIFIED BY 'NEUTRON_DBPASS';
GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'%' IDENTIFIED BY 'NEUTRON_DBPASS';
EOT

openstack user create --password=NEUTRON_PASS neutron
openstack role add --project service --user neutron admin
openstack service create --name neutron --description "OpenStack Networking" network
openstack endpoint create --publicurl http://controller:9696 --adminurl http://controller:9696 --internalurl http://controller:9696 --region RegionOne network

#apt-get install -y neutron-server neutron-plugin-ml2 python-neutronclient  

echo "Configuring Controller-Neutron..."

cp $home_dir/conf/neutron.conf /etc/neutron/neutron.conf
cp $home_dir/conf/ml2_conf.ini /etc/neutron/plugins/ml2/ml2_conf.ini
su -s /bin/sh -c "neutron-db-manage --config-file /etc/neutron/neutron.conf --config-file /etc/neutron/plugins/ml2/ml2_conf.ini upgrade head" neutron

service nova-api restart
service neutron-server restart

sleep 2
neutron ext-list

echo "Installing Network-Neutron..."

cp $home_dir/conf/sysctl.conf /etc/sysctl.conf

sysctl -p

#apt-get install -y neutron-plugin-ml2 neutron-plugin-openvswitch neutron-plugin-openvswitch-agent neutron-l3-agent neutron-dhcp-agent neutron-metadata-agent

echo "Configuring Network-Neutron..."

cp $home_dir/conf/l3_agent.ini /etc/neutron/l3_agent.ini
cp $home_dir/conf/dhcp_agent.ini /etc/neutron/dhcp_agent.ini
cp $home_dir/conf/metadata_agent.ini /etc/neutron/metadata_agent.ini





pkill dnsmasq
service openvswitch-switch restart
service neutron-plugin-openvswitch-agent restart
service neutron-l3-agent restart
service neutron-dhcp-agent restart
service neutron-metadata-agent restart
service neutron-server restart

sleep 2
neutron agent-list

echo "Neutron Finished"  


#------------------------------------------------------------------------#

## Horizon ##
echo "Installing Horizon"
#apt-get install -y openstack-dashboard

echo "Configuring Horizon"

#apt-get remove -y --purge openstack-dashboard-ubuntu-theme


cp $home_dir/conf/local_settings.py /etc/openstack-dashboard/local_settings.py 
cp $home_dir/conf/favicon.ico /usr/share/openstack-dashboard/static/dashboard/img/
cp $home_dir/conf/logo-splash.png /usr/share/openstack-dashboard/static/dashboard/img/
cp $home_dir/conf/logo.png /usr/share/openstack-dashboard/static/dashboard/img/

service apache2 reload

echo "Horizon Finished"


#------------------------------------------------------------------------#

## Ceilometer ##
echo "Installing Ceilometer"
mysql -u root -ppassword<<EOF
CREATE DATABASE ceilometer;
GRANT ALL PRIVILEGES ON ceilometer.* TO 'ceilometer'@'localhost' IDENTIFIED BY 'CEILOMETER_DBPASS';
GRANT ALL PRIVILEGES ON ceilometer.* TO 'ceilometer'@'%' IDENTIFIED BY 'CEILOMETER_DBPASS';
EOF

openstack user create --password CEILOMETER_PASS ceilometer
openstack role add --project service --user ceilometer admin
openstack service create --name ceilometer --description "Telemetry" metering
openstack endpoint create --publicurl http://controller:8777 --internalurl http://controller:8777 --adminurl http://controller:8777 --region RegionOne metering


#apt-get install -y ceilometer-api ceilometer-collector ceilometer-agent-central ceilometer-agent-notification ceilometer-alarm-evaluator ceilometer-alarm-notifier python-ceilometerclient ceilometer-agent-compute


echo "Configuring Ceilometer"

cp $home_dir/conf/ceilometer.conf /etc/ceilometer/ceilometer.conf
#cp /opt/naanal/controller/conf/pipeline.yaml /etc/ceilometer/pipeline.yaml

ceilometer-dbsync

service ceilometer-agent-central restart
service ceilometer-agent-notification restart
service ceilometer-api restart
service ceilometer-collector restart
service ceilometer-alarm-evaluator restart
service ceilometer-alarm-notifier restart
service ceilometer-agent-compute restart

source $home_dir/conf/admin-ceilorc.sh

sleep 5
ceilometer meter-list

source $home_dir/conf/admin-openrc.sh

echo "Ceilometer Finished"



#------------------------------------------------------------------------#



## Heat ##
echo "Installing Heat"
mysql -u root -ppassword<<EOF
CREATE DATABASE heat;
GRANT ALL PRIVILEGES ON heat.* TO 'heat'@'localhost' IDENTIFIED BY 'HEAT_DBPASS';
GRANT ALL PRIVILEGES ON heat.* TO 'heat'@'%' IDENTIFIED BY 'HEAT_DBPASS';
EOF


openstack user create --password HEAT_PASS heat
openstack role add --project service --user heat admin
openstack role create heat_stack_owner
openstack role add --project admin --user admin heat_stack_owner
openstack role create heat_stack_user

openstack service create --name heat --description "Orchestration" orchestration
openstack service create --name heat-cfn --description "Orchestration" cloudformation

openstack endpoint create --publicurl http://controller:8004/v1/%\(tenant_id\)s --internalurl http://controller:8004/v1/%\(tenant_id\)s --adminurl http://controller:8004/v1/%\(tenant_id\)s --region RegionOne orchestration

openstack endpoint create --publicurl http://controller:8000/v1 --internalurl http://controller:8000/v1 --adminurl http://controller:8000/v1 --region RegionOne cloudformation

#apt-get install -y heat-api heat-api-cfn heat-engine python-heatclient

#heat-keystone-setup-domain --stack-user-domain-name heat_user_domain --stack-domain-admin heat_domain_admin --stack-domain-admin-password HEAT_DOMAIN_PASS

stack_domain_id=$(heat-keystone-setup-domain --stack-user-domain-name heat_user_domain --stack-domain-admin heat_domain_admin --stack-domain-admin-password HEAT_DOMAIN_PASS | grep -oP 'id=[a-z0-9]*' | cut -f 2 -d '=')


echo "Configuring Heat"

cp $home_dir/conf/heat.conf /etc/heat/heat.conf
sed -i "s/SUDID/$stack_domain_id/" /etc/heat/heat.conf
su -s /bin/sh -c "heat-manage db_sync" heat


service heat-api restart
service heat-api-cfn restart
service heat-engine restart

mv /var/lib/heat/heat.sqlite /var/lib/heat/heat.sqlite.bkp 

sleep 5

heat stack-list
echo "Heat Finished"

#------------------------------------------------------------------------#

## Cider ##
echo "Installing Cinder"
mysql -u root -ppassword<<EOF
CREATE DATABASE cinder;
GRANT ALL PRIVILEGES ON cinder.* TO 'cinder'@'localhost' IDENTIFIED BY 'CINDER_DBPASS';
GRANT ALL PRIVILEGES ON cinder.* TO 'cinder'@'%' IDENTIFIED BY 'CINDER_DBPASS';
EOF

openstack user create --password CINDER_PASS cinder
openstack role add --project service --user cinder admin

openstack service create --name cinder --description "OpenStack Block Storage" volume
openstack service create --name cinderv2 --description "OpenStack Block Storage" volumev2

openstack endpoint create --publicurl http://controller:8776/v2/%\(tenant_id\)s --internalurl http://controller:8776/v2/%\(tenant_id\)s --adminurl http://controller:8776/v2/%\(tenant_id\)s --region RegionOne volume

openstack endpoint create --publicurl http://controller:8776/v2/%\(tenant_id\)s \
--internalurl http://controller:8776/v2/%\(tenant_id\)s --adminurl http://controller:8776/v2/%\(tenant_id\)s --region RegionOne volumev2

#apt-get install -y cinder-api cinder-scheduler python-cinderclient cinder-volume python-mysqldb qemu lvm2 tcm 

echo "Configuring Cinder"

cp $home_dir/conf/cinder.conf /etc/cinder/cinder.conf
#cp /opt/naanal/controller/conf/lvm.conf /etc/lvm/lvm.conf

sed -i "s/EXT_IP/$ops_ip/" /etc/cinder/cinder.conf
#sed -i "s/CINDER_VOLUME/$cinder_volume/" /etc/lvm/lvm.conf


su -s /bin/sh -c "cinder-manage db sync" cinder

#creating Logical Volume#
#pvcreate /dev/$cinder_volume
#vgcreate cinder-volumes /dev/$cinder_volume

mv /var/lib/cinder/cinder.sqlite /var/lib/cinder/cinder.sqlite.bkp

service cinder-scheduler restart
service cinder-api restart
service cinder-volume restart
service tgt restart

sleep 2

cinder service-list
echo "Ceilometer Finished"


#------------------------------------------------------------------------#

end_time=`date +%s`
tot_time=$(($end_time-$start_time))
echo Total Time Taken $tot_time seconds


openstack token issue
glance image-list
nova service-list
neutron ext-list
neutron agent-list
neutron net-list
ceilometer meter-list
heat stack-list
cinder service-list

echo "Initiatilizing Networks..."

neutron net-create wan-net --router:external  --provider:physical_network wan-phy-net --provider:network_type flat

neutron subnet-create wan-net $wan_cidr --name wan-subnet --allocation-pool start=$wan_ip_start,end=$wan_ip_end --disable-dhcp --gateway $wan_gateway

neutron net-create lan-net --provider:network_type flat --provider:physical_network lan-phy-net

neutron subnet-create lan-net --name lan-subnet --gateway $lan_gateway $lan_cidr

neutron router-create naanal-vrouter
neutron router-interface-add naanal-vrouter lan-subnet
neutron router-gateway-set naanal-vrouter wan-net

echo "Neutron Initialization Finished"  
