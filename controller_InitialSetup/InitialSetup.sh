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
	touch First
        /usr/bin/python interfaces.py
	reboot

elif [ ! -f "/opt/naanal/controller_InitialSetup/Second" ]; then 
	touch /opt/naanal/controller_InitialSetup/Second
        cd /opt/naanal/controller/setup 
	/bin/bash controller_setup_part_1.sh
elif [ ! -f "/opt/naanal/controller_InitialSetup/Third" ]; then
	touch /opt/naanal/controller_InitialSetup/Third
	cd /opt/naanal/controller/setup 
	/bin/bash controller_setup_part_2.sh
elif [ ! -f "/opt/naanal/controller_InitialSetup/Fourth" ]; then
	touch /opt/naanal/controller_InitialSetup/Fourth
        cd /opt/naanal/controller/setup 
	/bin/bash controller_setup_part_3.sh
elif [ ! -f "/opt/naanal/controller_InitialSetup/Fifth" ]; then
	touch /opt/naanal/controller_InitialSetup/Fifth
        cd /opt/naanal/controller/setup 
	/bin/bash controller_setup_part_4.sh
fi

