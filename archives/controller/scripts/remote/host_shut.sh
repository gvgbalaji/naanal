#!/bin/sh

operation=$1

for i in `mysql -u root -ppassword<<EOF
select id from nova.instances where power_state=1 and deleted=0 and vm_state!='deleted';
EOF`;
do
        if [ "$i" != "id" ];
        then
        	id=$(printf "%08x" $i)
		echo "Shutting Down instance-$id"
		virsh shutdown instance-$id
	fi
done

if [ "$operation" = "shutdown" ];
then
	at -f shut.sh now+1minutes
elif [ "$operation" = "reboot" ];
then
	at -f rebo.sh now+1minutes
fi

	
