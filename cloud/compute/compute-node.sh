controller_ip=192.168.1.230
compute_ip=192.168.1.231
gateway=192.168.1.1
netmask=255.255.255.0
mgmt_port=eth0
data_port=eth1

### PACKAGE INSTALLATION ###

apt-get install -y ubuntu-cloud-keyring

echo "deb http://ubuntu-cloud.archive.canonical.com/ubuntu" \
"trusty-updates/kilo main" > /etc/apt/sources.list.d/cloudarchive-kilo.list
apt-get update

apt-get install -y ntp nova-compute sysfsutils neutron-plugin-ml2 neutron-plugin-openvswitch-agent


### NETWORKING ###
ovs-vsctl add-br br-lan
ovs-vsctl add-port br-lan $data_port

cp /etc/network/interfaces /etc/network/interfaces.bkp
cp interfaces /etc/network/ 

sed -i -e "s/MGMT_PORT/$mgmt_port/" -e "s/DATA_PORT/$data_port/" -e "s/COMPUTE_IP/$compute_ip/" -e "s/GATEWAY_IP/$gateway/" -e "s/NETMASK/$netmask/" /etc/network/interfaces

echo $controller_ip controller >> /etc/hosts

sed -i -e "s/^server/#server/" /etc/ntp.conf
echo "server $controller_ip" >> /etc/ntp.conf
service ntp restart 
ntpq -p


### NOVA CONFIGURATION ###

cp /etc/nova/nova.conf /etc/nova/nova.conf.bkp
cp nova.conf /etc/nova/

sed -i -e "s/COMPUTE_IP/$compute_ip/" -e "s/CONTROLLER_IP/$controller_ip/" /etc/nova/nova.conf

rm -f /var/lib/nova/nova.sqlite

chmod -R 777 /var/log/nova/

### NEUTRON CONFIGURATION ###

echo "net.ipv4.conf.all.rp_filter=0" >> /etc/sysctl.conf
echo "net.ipv4.conf.default.rp_filter=0" >> /etc/sysctl.conf
echo "net.bridge.bridge-nf-call-iptables=1" >> /etc/sysctl.conf
echo "net.bridge.bridge-nf-call-ip6tables=1" >> /etc/sysctl.conf

sysctl -p

cp /etc/neutron/neutron.conf /etc/neutron/neutron.conf.bkp
cp neutron.conf /etc/neutron/

cp /etc/neutron/plugins/ml2/ml2_conf.ini /etc/neutron/plugins/ml2/ml2_conf.ini.bkp
cp ml2_conf.ini /etc/neutron/plugins/ml2/

chmod -R 777 /var/log/neutron/

service openvswitch-switch restart
service neutron-plugin-openvswitch-agent restart
service nova-compute restart

reboot
