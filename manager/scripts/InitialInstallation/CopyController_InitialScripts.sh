#!/bin/bash

host_ip=192.168.1.230
#Copies controller_InitialSetup 
sshpass -p "password" scp -r /opt/naanal/controller_InitialSetup  root@$host_ip:/opt/naanal/

#In all the files Dos2Unix is executed and execute permission is provided
sshpass -p 'password' ssh -o StrictHostKeyChecking=no root@$host_ip 'find /opt/naanal/controller_InitialSetup -type f -exec dos2unix {} \;'
sshpass -p 'password' ssh -o StrictHostKeyChecking=no root@$host_ip 'find /opt/naanal/controller_InitialSetup -type f -exec chmod +x {} \;'
sshpass -p 'password' ssh -o StrictHostKeyChecking=no root@$host_ip '/bin/bash /opt/naanal/controller_InitialSetup/InitialSetup.sh'

