#!/bin/bash

# Make sure only root can run our script
if [ "$(id -u)" != "0" ]; then
   echo "You need to be 'root' dude." 1>&2
   exit 1
fi

echo "PART 4/4: Setting up Naanal Webapp "

cd /opt/naanal/webapp/scripts && ./webapp_deploy.sh
cp /opt/naanal/controller/setup/rc.local /etc/

echo "INFO: Naanal  Controller ready !!!"
echo "WARNING: System going to reboot. After reboot, start using the system"

sleep 3;

#reboot

exit

