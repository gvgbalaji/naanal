#!/bin/bash

# Make sure only root can run our script
if [ "$(id -u)" != "0" ]; then
   echo "You need to be 'root' dude." 1>&2
   exit 1
fi

source /opt/naanal/controller/env/setuprc
/opt/naanal/controller/scripts/openstack_reset_topology.sh

wan_nic=br-wan
wan_ip=$(/sbin/ifconfig $wan_nic| sed -n 's/.*inet *addr:\([0-9\.]*\).*/\1/p' | cut -d '.' -f 1,2,3)
lan_ip=10.0.0

nova quota-class-update --instances 60 default
nova quota-class-update --cores 120 default
nova quota-class-update --floating_ips 60 default
nova quota-class-update --ram 65536 default

nova secgroup-add-rule default tcp 1 65535 0.0.0.0/0
nova secgroup-add-rule default udp 1 65535 0.0.0.0/0
nova secgroup-add-rule default icmp -1 -1 0.0.0.0/0

nova flavor-create m1.naanal 6 1024 20 1 --ephemeral 0 --swap 0 --is-public True

neutron net-create lan-net --provider:network_type flat --provider:physical_network lan-phy-net 
neutron subnet-create lan-net --name lan-subnet --gateway $lan_ip.1 $lan_ip.0/24
neutron router-create naanal-vrouter
neutron router-interface-add naanal-vrouter lan-subnet
neutron net-create wan-net --provider:network_type flat --provider:physical_network wan-phy-net --shared --router:external=True
neutron subnet-create wan-net --name wan-subnet --disable-dhcp --gateway $wan_ip.1 $wan_ip.0/24 --allocation-pool start=$wan_ip.240,end=$wan_ip.250
neutron router-gateway-set naanal-vrouter wan-net
#glance image-create --name="Ubuntui 14.04 " --container-format=bare --disk-format=qcow2 --file=/opt/naanal_images/trusty-server-cloudimg-amd64-disk1.img
#glance image-create --name Cirros --is-public true --container-format bare --disk-format qcow2 --location https://launchpad.net/cirros/trunk/0.3.0/+download/cirros-0.3.0-x86_64-disk.img
glance image-create --name="Cirros"  --is-public true --container-format=bare --disk-format=qcow2 --file=/opt/naanal/images/cirros-0.3.0-x86_64-disk.img
#glance image-create --name="Win7 Ulti"  --container-format=bare --disk-format=qcow2 --file=/opt/naanal/images/win7_snap.img
#glance image-create --name="Windows 7"  --container-format=bare --disk-format=qcow2 --file=/opt/naanal/images/win7_snap.img
#glance image-create --name="Ubuntu Linux" --container-format=bare --disk-format=qcow2 --file=/opt/naanal/images/trusty-server-cloudimg-amd64-disk1.img

exit
