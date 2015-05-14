#!/bin/sh
cd /opt/naanal/controller/setup
chmod +x *

if [ ! -f "/opt/naanal/controller_InitialSetup/Zeroth" ]; then
	cd /opt/naanal/controller_InitialSetup/
	touch Zeroth
    cp conf/rc.local /etc/
	reboot

elif [ ! -f "/opt/naanal/controller_InitialSetup/First" ]; then
	cd /opt/naanal/controller_InitialSetup/
	/usr/bin/python interfaces.py
	touch First
	reboot

elif [ ! -f "/opt/naanal/controller_InitialSetup/Second" ]; then 
	cd /opt/naanal/controller/setup 
	/bin/bash controller_setup_part_1.sh
	touch /opt/naanal/controller_InitialSetup/Second
	reboot
	
elif [ ! -f "/opt/naanal/controller_InitialSetup/Third" ]; then
	cd /opt/naanal/controller/setup 
	/bin/bash controller_setup_part_2.sh
	touch /opt/naanal/controller_InitialSetup/Third
	reboot
	
elif [ ! -f "/opt/naanal/controller_InitialSetup/Fourth" ]; then
	cd /opt/naanal/controller/setup 
	/bin/bash controller_setup_part_3.sh
	touch /opt/naanal/controller_InitialSetup/Fourth
	reboot
	
elif [ ! -f "/opt/naanal/controller_InitialSetup/Fifth" ]; then
	cd /opt/naanal/controller/setup 
	/bin/bash controller_setup_part_4.sh
	touch /opt/naanal/controller_InitialSetup/Fifth
	reboot
fi

