#!/bin/bash
openstack_host=192.168.1.230

sshpass -p 'password' ssh $openstack_host -l root -o StrictHostKeyChecking=no "at -f /opt/naanal/controller/scripts/remote/vm_shut.sh now"


backup_dir="/media/external/backup/mysql"
filename="${backup_dir}/mysql-`eval date +%Y%m%d`"
rm -r ${filename}
mkdir ${filename}
# Dump the entire MySQL database
        mysqldump -h ${openstack_host} -u root -ppassword  nova > ${filename}/nova.sql
        mysqldump -h ${openstack_host} -u root -ppassword  glance > ${filename}/glance.sql
        mysqldump -h ${openstack_host} -u root -ppassword  cinder > ${filename}/cinder.sql


backup_dir="/media/external/backup/openstack/openstack-`eval date +%Y%m%d`"
filename="${backup_dir}/etc"
rm -r ${backup_dir}
mkdir ${backup_dir}
mkdir ${filename}

sshpass -p "password" scp -r root@${openstack_host}:/etc/nova ${filename}
sshpass -p "password" scp -r root@${openstack_host}:/etc/glance ${filename}
sshpass -p "password" scp -r root@${openstack_host}:/etc/keystone ${filename}
sshpass -p "password" scp -r root@${openstack_host}:/etc/neutron ${filename}
sshpass -p "password" scp -r root@${openstack_host}:/etc/cinder ${filename}
filename="${backup_dir}/lib"
mkdir ${filename}
sshpass -p "password" scp -r root@${openstack_host}:/var/lib/nova ${filename}
sshpass -p "password" scp -r root@${openstack_host}:/var/lib/glance ${filename}
sshpass -p "password" scp -r root@${openstack_host}:/var/lib/keystone ${filename}
sshpass -p "password" scp -r root@${openstack_host}:/var/lib/neutron ${filename}
sshpass -p "password" scp -r root@${openstack_host}:/var/lib/cinder ${filename}


