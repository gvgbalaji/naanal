#!/bin/bash

# Make sure only root can run our script
if [ "$(id -u)" != "0" ]; then
   echo "You need to be 'root' dude." 1>&2
   exit 1
fi

mysql_passwd=password

# kill them.  kill them all.
mysql -u root --password=$mysql_passwd <<EOF
DROP DATABASE keystone;
DROP DATABASE glance;
DROP DATABASE nova;
DROP DATABASE neutron;
EOF

virsh list --inactive | grep instance | cut -d' ' -f7 | xargs -n 1 virsh undefine 2>/dev/null || true


# remove openstack
sudo apt-get autoremove -y --purge ntp python-mysqldb mysql-server keystone glance rabbitmq-server nova-volume nova-novncproxy nova-api nova-ajax-console-proxy nova-cert nova-consoleauth nova-doc nova-scheduler nova-network nova-compute memcached cinder-api cinder-scheduler cinder-volume iscsitarget open-iscsi iscsitarget-dkms python-cinderclient tgt neutron-server neutron-plugin-openvswitch neutron-plugin-openvswitch-agent neutron-common neutron-dhcp-agent neutron-l3-agent neutron-metadata-agent openvswitch-switch

rm -rf /var/lib/nova /var/lib/glance /var/lib/mysql /var/lib/libvirt/ /var/log/nova /var/log/glance /etc/mysql /var/log/cinder /var/lib/cinder /var/log/neutron /var/lib/neutron

rm -rf /etc/keystone/ /etc/nova/ /etc/cinder/ /etc/glance/ /etc/neutron


exit
