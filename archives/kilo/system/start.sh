#!/bin/bash

# Make sure only root can run our script
if [ "$(id -u)" != "0" ]; then
   echo "You need to be 'root' dude." 1>&2
   exit 1
fi


service networking restart;

service mysql restart;

service keystone restart;
service glance-api restart;
service glance-registry restart;
service nova-api restart ;
service nova-cert restart; 
service nova-consoleauth restart ;
service nova-scheduler restart;
service nova-conductor restart; 
service nova-novncproxy restart; 
service nova-compute restart; 
service nova-console restart

service neutron-server restart; 
service neutron-plugin-openvswitch-agent restart;
service neutron-metadata-agent restart; 
service neutron-dhcp-agent restart; 
service neutron-l3-agent restart

 
exit

