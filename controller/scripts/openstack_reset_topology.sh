source /opt/naanal/controller/env/setuprc

neutron router-interface-delete naanal-vrouter lan-subnet
neutron router-delete naanal-vrouter
neutron net-delete wan-net
neutron net-delete lan-net

