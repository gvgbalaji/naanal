<?php
$overviewnav=array("SUMMARY","USER MONITOR","APPLICATION MONITOR","WEB MONITOR");
$topnav=array("GROUP","USERS");
//$leftnav=array("OVERVIEW","USER CONTROL","NETWORK","FIREWALL","WEB FILTER","APPLICATION FILTER","BANDWIDTH CONTROL","TIME ACCESS CONTROL","VDI");
$cycleperiod=array("Day","Night");
$actn=array("Allow","Block");
$netnav=array("Interfaces","Gateway","Static Routes","ARP","DNS","DHCP");
$netzone=array("LAN","WAN","DMZ","Unbound");
$ifspeed=array("Auto_Negotiatable","10Mbps","100Mbps");
$netmask=array("255.255.255.0","255.255.0.0","255.0.0.0");
$nat_policy=array("MASQ");
$firewallnav=array("Rules","NAT");
$priority=array("","High","Medium","Low");
$color =array("42C0FB","e39e54","0ceec6","fde249","046169","fffab2","336633","0eb04b","c2fe81","b70000");
$num_list = array(3,4,5,10,15,20);
$auth_cmd="--os-username admin --os-password ADMIN --os-tenant-name admin --os-auth-url ";
$policy_nm="policy1";
$power_state=array("NoState","Running","NoState","PAUSED","Shutdown","NoState","Crashed","Suspended","Nostate","Building");
//$vdinav=array("Overview","Instances","Flavors","Firewall","Floatingip","Images");
$leftnav=array("OVERVIEW","INSTANCES","FLAVORS","FIREWALL","FLOATINGIP","IMAGES","SYSTEM","USERS");
$num_ins=array(10,15,30);
$ins_limit=$num_ins[2];
$vm_limit=10;
$core_multiplier=7.5;

?>
