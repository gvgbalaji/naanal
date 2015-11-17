#!/bin/sh

 
. /opt/naanal/controller/env/setuprc

sleep 10

for i in `mysql -u root -ppassword<<EOF
select display_name from nova.instances where power_state=1 and deleted=0 and vm_state!='deleted';
EOF`;
do
        if [ "$i" != "display_name" ];
        then
                echo "Powering Off $i"
                nova stop $i
        fi
sleep 2
done

shutdown -r now
