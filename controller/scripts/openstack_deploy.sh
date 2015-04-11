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

# kill them.  kill them all.
mysql -u root --password=$mysql_passwd <<EOF
DROP DATABASE keystone;
DROP DATABASE glance;
DROP DATABASE nova;
DROP DATABASE neutron;
DROP DATABASE ceilometer;
DROP DATABASE cinder;
EOF

#virsh list --inactive | grep instance | cut -d' ' -f7 | xargs -n 1 virsh undefine 2>/dev/null || true
virsh list --all | grep instance | cut -d' ' -f7 | xargs -n 1 virsh undefine 2>/dev/null || true

rm -rf temp
cp -rf ../conf temp

grep -rl "NAANAL_EXT_IP" ./temp | xargs sed -i "s@NAANAL_EXT_IP@$ext_ip@g"

cp ./temp/my.cnf  /etc/mysql/my.cnf
cp ./temp/keystone.conf  /etc/keystone/keystone.conf
cp ./temp/glance-api.conf  /etc/glance/glance-api.conf
cp ./temp/glance-registry.conf  /etc/glance/glance-registry.conf
cp ./temp/nova.conf  /etc/nova/nova.conf
cp ./temp/neutron.conf  /etc/neutron/neutron.conf
cp ./temp/ml2_conf.ini  /etc/neutron/plugins/ml2/ml2_conf.ini
cp ./temp/metadata_agent.ini  /etc/neutron/metadata_agent.ini
cp ./temp/dhcp_agent.ini  /etc/neutron/dhcp_agent.ini
cp ./temp/l3_agent.ini  /etc/neutron/l3_agent.ini
cp ./temp/ceilometer.conf  /etc/ceilometer/
cp ./temp/pipeline.yaml  /etc/ceilometer/
cp ./temp/cinder.conf  /etc/cinder/
cp ./temp/variables.py  /usr/lib/python2.7/

rm -rf ./temp

service mysql restart

###### KEYSTONE #########
mysql -u root --password=$mysql_passwd <<EOF
CREATE DATABASE keystone;
GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'%' IDENTIFIED BY 'keystone_dbpass';
CREATE DATABASE glance;
GRANT ALL ON glance.* TO 'glance'@'%' IDENTIFIED BY 'glance_dbpass';
CREATE DATABASE nova;
GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'%' IDENTIFIED BY 'nova_dbpass';
CREATE DATABASE neutron;
GRANT ALL ON neutron.* TO 'neutron'@'%' IDENTIFIED BY 'neutron_dbpass';
CREATE DATABASE ceilometer;
GRANT ALL PRIVILEGES ON ceilometer.* TO 'ceilometer'@'localhost' IDENTIFIED BY 'ceilometer_dbpass';
GRANT ALL PRIVILEGES ON ceilometer.* TO 'ceilometer'@'%' IDENTIFIED BY 'ceilometer_dbpass';
CREATE DATABASE cinder;
GRANT ALL PRIVILEGES ON cinder.* TO 'cinder'@'localhost' IDENTIFIED BY 'cinder_dbpass';
GRANT ALL PRIVILEGES ON cinder.* TO 'cinder'@'%' IDENTIFIED BY 'cinder_dbpass';
EOF

service keystone restart
keystone-manage db_sync

echo "
export OS_SERVICE_TOKEN=ADMIN
export OS_SERVICE_ENDPOINT=http://$ext_ip:35357/v2.0
export OS_USERNAME=admin
export OS_PASSWORD=ADMIN
export OS_TENANT_NAME=admin
export OS_AUTH_URL=http://$ext_ip:35357/v2.0
" > ../env/setuprc

source ../env/setuprc

keystone tenant-create --name=admin --description="Admin Tenant"
keystone tenant-create --name=service --description="Service Tenant"
keystone user-create --name=admin --pass=ADMIN --email=admin@example.com
keystone role-create --name=admin
keystone user-role-add --user=admin --tenant=admin --role=admin
keystone service-create --name=keystone --type=identity --description="Keystone Identity Service"
keystone endpoint-create --service=keystone --publicurl=http://$ext_ip:5000/v2.0 --internalurl=http://$ext_ip:5000/v2.0 --adminurl=http://$ext_ip:35357/v2.0

keystone token-get
keystone user-list


########## GLANCE ##########

keystone user-create --name=glance --pass=glance_pass --email=glance@example.com
keystone user-role-add --user=glance --tenant=service --role=admin
keystone service-create --name=glance --type=image --description="Glance Image Service"
keystone endpoint-create --service=glance --publicurl=http://$ext_ip:9292 --internalurl=http://$ext_ip:9292 --adminurl=http://$ext_ip:9292

service glance-api restart
service glance-registry restart
glance-manage db_sync

mysql -u root --password=$mysql_passwd <<EOF
USE glance;
alter table migrate_version convert to character set utf8 collate utf8_unicode_ci;
flush privileges;
EOF

glance-manage db_sync


#glance image-create --name Cirros --is-public true --container-format bare --disk-format qcow2 --location https://launchpad.net/cirros/trunk/0.3.0/+download/cirros-0.3.0-x86_64-disk.img
#glance image-create --name="Ubuntu Trusty 14.04 LTS"  --container-format=bare --disk-format=qcow2 --file=/opt/naanal_images/trusty-server-cloudimg-amd64-disk1.img

glance index

######### NOVA ###########

keystone user-create --name=nova --pass=nova_pass --email=nova@example.com
keystone user-role-add --user=nova --tenant=service --role=admin
keystone service-create --name=nova --type=compute --description="OpenStack Compute"
keystone endpoint-create --service=nova --publicurl=http://$ext_ip:8774/v2/%\(tenant_id\)s --internalurl=http://$ext_ip:8774/v2/%\(tenant_id\)s --adminurl=http://$ext_ip:8774/v2/%\(tenant_id\)s

nova-manage db sync

service nova-api restart ;
service nova-cert restart; 
service nova-consoleauth restart ;
service nova-scheduler restart;
service nova-conductor restart; 
service nova-novncproxy restart; 
service nova-compute restart; 
service nova-console restart

nova-manage service list

nova list

######## NEUTRON #########


keystone user-create --name=neutron --pass=neutron_pass --email=neutron@example.com
keystone service-create --name=neutron --type=network --description="OpenStack Networking"
keystone user-role-add --user=neutron --tenant=service --role=admin
keystone endpoint-create --service=neutron --publicurl http://$ext_ip:9696 --adminurl http://$ext_ip:9696  --internalurl http://$ext_ip:9696

ovs-vsctl add-br br-int
ovs-vsctl add-br br-lan
ovs-vsctl add-br br-wan
ovs-vsctl add-port br-lan port-lan0
ovs-vsctl add-port br-lan port-lan1
ovs-vsctl add-port br-lan port-lan2
ovs-vsctl add-port br-lan port-lan3
ovs-vsctl add-port br-wan port-wan

service neutron-server restart; 
service neutron-plugin-openvswitch-agent restart;
service neutron-metadata-agent restart; 
service neutron-dhcp-agent restart; 
service neutron-l3-agent restart

sleep 3;

neutron agent-list

######## CEILOMETER #########
keystone user-create --name=ceilometer --pass=ceilometer_pass --email=ceilometer@example.com
keystone service-create --name=ceilometer --type=metering --description="Telemetry"
keystone user-role-add --user=ceilometer --tenant=service --role=admin
keystone endpoint-create --service-id=$(keystone service-list | awk '/ metering / {print $2}') --publicurl=http://$ext_ip:8777 --internalurl=http://$ext_ip:8777 --adminurl=http://$ext_ip:8777

ceilometer-dbsync

service ceilometer-agent-central restart
service ceilometer-agent-notification restart
service ceilometer-api restart
service ceilometer-collector restart
service ceilometer-alarm-evaluator restart
service ceilometer-alarm-notifier restart
service nova-compute restart
service ceilometer-agent-compute restart
###########

######## CINDER #########

rm -f /var/lib/cinder/cinder.sqlite

su -s /bin/sh -c "cinder-manage db sync" cinder

keystone user-create --name=cinder --pass=cinder-pass --email=cinder@example.com
keystone user-role-add --user=cinder --tenant=service --role=admin
keystone service-create --name=cinder --type=volume --description="OpenStack Block Storage"


keystone endpoint-create --service-id=$(keystone service-list | awk '/ volume / {print $2}') --publicurl=http://$ext_ip:8776/v1/%\(tenant_id\)s --internalurl=http://$ext_ip:8776/v1/%\(tenant_id\)s --adminurl=http://$ext_ip:8776/v1/%\(tenant_id\)s

keystone service-create --name=cinderv2 --type=volumev2 --description="OpenStack Block Storage v2"

keystone endpoint-create --service-id=$(keystone service-list | awk '/ volumev2 / {print $2}') --publicurl=http://$ext_ip:8776/v2/%\(tenant_id\)s --internalurl=http://$ext_ip:8776/v2/%\(tenant_id\)s --adminurl=http://$ext_ip:8776/v2/%\(tenant_id\)s

service cinder-scheduler restart 
service cinder-api restart
service cinder-volume restart
service tgt restart

###########


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

./cpu_mem_usage.py
 
exit
