#!/bin/bash

#To move the conf files to Initial Installation folder
mv /var/www/html/conf/confrc /opt/naanal/manager/scripts/InitialInstallation
cd /opt/naanal/manager/scripts/InitialInstallation

#To place External Ip address
ext_ip=`grep  "EXT_IP_ADDR" confrc | cut -d"=" --complement -f1`
echo $ext_ip
grep -rl EXT_IP_ADDR /opt/naanal/controller  | xargs sed -i "s@EXT_IP_ADDR@$ext_ip@g"

#To place the Controller Ip
sed -i "s@EXT_IP_ADDR@$ext_ip@g" CopyControllerFolder.sh

#To place WAN Interface Name
wan_nm=`grep  "WAN_NM" confrc | cut -d"=" --complement -f1`
echo $wan_nm
grep -rl WAN_NM /opt/naanal/controller  | xargs sed -i "s@WAN_NM@$wan_nm@g"

#To place LAN Interface Name
lan_nm=`grep  "LAN_NM" confrc | cut -d"=" --complement -f1`
echo $lan_nm
grep -rl LAN_NM /opt/naanal/controller  | xargs sed -i "s@LAN_NM@$lan_nm@g"

#To place WAN Gateway
wan_gateway=`grep  "WAN_GATEWAY" confrc | cut -d"=" --complement -f1`
echo $wan_gateway
grep -rl WAN_GATEWAY /opt/naanal/controller  | xargs sed -i "s@WAN_GATEWAY@$wan_gateway@g"

#To place LAN Subnet
lan_subnet=`grep  "LAN_SUBNET" confrc | cut -d"=" --complement -f1`
echo $lan_subnet
grep -rl LAN_SUBNET /opt/naanal/controller  | xargs sed -i "s@LAN_SUBNET@$lan_subnet@g"

#To place DNS NameServer
dnsServerEntry=`grep  "DNS_NAMESERVER" confrc | cut -d"=" --complement -f1`
echo $dnsServerEntry
grep -rl DNS_NAMESERVER /opt/naanal/controller  | xargs sed -i "s@DNS_NAMESERVER@$dnsServerEntry@g"

#To place Secondary Drives
secondaryHD=`grep  "SECONDARY_HD" confrc | cut -d"=" --complement -f1`
echo $secondaryHD
grep -rl SECONDARY_HD /opt/naanal/controller  | xargs sed -i "s@SECONDARY_HD@$secondaryHD@g"

#To Copy the Controller Files to Controller Machine
cd /opt/naanal/manager/scripts/InitialInstallation && ./CopyControllerFolder.sh

#To send signal to Controller stating that it is ready to begin installation
cd /opt/naanal/manager/scripts/InitialInstallation && ./zmq_sig.py