#!/bin/bash

# Make sure only root can run our script
if [ "$(id -u)" != "0" ]; then
   echo "You need to be 'root' dude." 1>&2
   exit 1
fi

echo "PART 2/3: Setting bridges, ports, interface settings appropriately"

ovs-vsctl add-br br-int
ovs-vsctl add-br br-lan
ovs-vsctl add-br br-wan
ovs-vsctl add-port br-lan port-lan0
#ovs-vsctl add-port br-lan port-lan1
#ovs-vsctl add-port br-lan port-lan2
#ovs-vsctl add-port br-lan port-lan3
ovs-vsctl add-port br-wan port-wan

ovs-vsctl del-br br-ex
ovs-vsctl del-br br-eth1

cp -rf /opt/naanal/controller/conf/interfaces /etc/network/

echo "WARNING: System going to reboot. After reboot run ./controller_setup_part_3.sh"

sleep 3;

#reboot

exit

