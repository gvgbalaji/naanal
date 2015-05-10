#!/bin/bash
ext_ip=`grep  "EXT_IP_ADDR" /opt/naanal/manager/scripts/InitialInstallation/ParamEntries.conf | cut -d"=" --complement -f1`
echo $ext_ip
grep -rl EXT_IP_ADDR /opt/naanal/controller  | xargs sed -i "s@EXT_IP@$ext_ip@g"

wan_nm=`grep  "WAN_NM" /opt/naanal/manager/scripts/InitialInstallation/ParamEntries.conf | cut -d"=" --complement -f1`
echo $wan_nm
grep -rl WAN_NM /opt/naanal/controller  | xargs sed -i "s@WAN_NM@$wan_nm@g"


lan_nm=`grep  "LAN_NM" /opt/naanal/manager/scripts/InitialInstallation/ParamEntries.conf | cut -d"=" --complement -f1`
echo $lan_nm
grep -rl LAN_NM /opt/naanal/controller  | xargs sed -i "s@LAN_NM@$lan_nm@g"

wan_gateway=`grep  "WAN_GATEWAY" /opt/naanal/manager/scripts/InitialInstallation/ParamEntries.conf | cut -d"=" --complement -f1`
echo $wan_gateway
grep -rl WAN_GATEWAY /opt/naanal/controller  | xargs sed -i "s@WAN_GATEWAY@$wan_gateway@g"

lan_subnet=`grep  "LAN_SUBNET" /opt/naanal/manager/scripts/InitialInstallation/ParamEntries.conf | cut -d"=" --complement -f1`
echo $lan_subnet
grep -rl LAN_SUBNET /opt/naanal/controller  | xargs sed -i "s@LAN_SUBNET@$lan_subnet@g"


dnsServerEntry=`grep  "DNS_NAMESERVER" /opt/naanal/manager/scripts/InitialInstallation/ParamEntries.conf | cut -d"=" --complement -f1`
echo $dnsServerEntry
grep -rl DNS_NAMESERVER /opt/naanal/controller  | xargs sed -i "s@DNS_SERVER_ENTRY@$dnsServerEntry@g"

secondaryHD=`grep  "SECONDARY_HD" /opt/naanal/manager/scripts/InitialInstallation/ParamEntries.conf | cut -d"=" --complement -f1`
echo $secondaryHD
grep -rl SECONDARY_HD /opt/naanal/controller  | xargs sed -i "s@SECONDARY_HD@$secondaryHD@g"