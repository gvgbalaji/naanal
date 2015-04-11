#!/bin/bash

# Make sure only root can run our script
if [ "$(id -u)" != "0" ]; then
   echo "You need to be 'root' dude." 1>&2
   exit 1
fi

echo "PART 5/3: Setting OpenStack components and Naanal topology"

cd /opt/naanal/controller/scripts && ./openstack_deploy.sh
source /opt/naanal/controller/env/setuprc
cd /opt/naanal/controller/scripts && ./openstack_set_topology.sh

echo "INFO: Naanal OPenStack completed!!!"
echo "WARNING: System going to reboot. After reboot run ./controller_setup_part_4.sh"

sleep 3;

#reboot

exit
