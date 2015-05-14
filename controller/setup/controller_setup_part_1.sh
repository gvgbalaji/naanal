#!/bin/bash

# Make sure only root can run our script
if [ "$(id -u)" != "0" ]; then
   echo "You need to be 'root' dude." 1>&2
   exit 1
fi

echo "PART 1/3: Setting interface name appropriately"

rm -rf /lib/udev/rules.d/75-persistent-net-generator.rules
rm -rf /etc/udev/rules.d/70-persistent-net.rules 
cp /opt/naanal/controller/conf/70-persistent-net.rules /etc/udev/rules.d/
echo "WARNING: System going to reboot. After reboot run ./controller_setup_part_2.sh"

sleep 3;

#reboot

exit

