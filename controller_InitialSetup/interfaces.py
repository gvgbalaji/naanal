#!/usr/bin/python
import commands
import MySQLdb
import psutil
import os
import re
import zmq

tableNM="initial_configuration"
userNM="root"
passwrd="password"
hostIp="192.168.204.137"
dbName="naanal"
conn=MySQLdb.connect(hostIp,userNM,passwrd,dbName)
openstack_ip="192.168.204.135"
cursor=conn.cursor()

mysql_exec = "drop table naanal."+tableNM+";"
cursor.execute(mysql_exec)
mysql_exec ="create table naanal.initial_configuration(field_name char(100),field_id char(100) primary key,value char(100),editable bool);"
cursor.execute(mysql_exec)
mysql_exec="""insert into naanal.initial_configuration values('Openstack IP','EXT_IP_ADDR','192.168.1.230',1),
('LAN IP','LAN_SUBNET','10.0.0.0',1),
('WAN Interface Name','WAN_NM','eth0',1),
('LAN Interface Name','LAN_NM','eth1',1),
('WAN Gateway','WAN_GATEWAY','192.168.1.1',1),
('DNS Nameserver','DNS_NAMESERVER','8.8.8.8',1),
('Secondary Drives','SECONDARY_HD','/dev/sdb  /dev/sdc',1),
('Number of CPUs','CPU_CORES','2',1),
('Total RAM','TOTAL_RAM','8',1);"""
cursor.execute(mysql_exec)

Wan= "'" + commands.getoutput("/sbin/ip -4 -o a | cut -d ' ' -f 2,7 | cut -d '/' -f1 | grep 192.168.204.135 | cut -d' ' -f1") +"'"
print Wan
mysql_exec="update " + tableNM + " set value=" + Wan + " where field_id='br-wan'"
cursor.execute(mysql_exec)

Lan= "'" +  commands.getoutput("/sbin/ip -4 -o a | cut -d ' ' -f 2,7 | cut -d '/' -f1 | grep 'eth0\|wlan\|eth1'  | cut -d' ' -f1") +"'"
print Lan
mysql_exec="update " + tableNM + " set value=" + Lan + " where field_id='a'"
cursor.execute(mysql_exec)

cpu_cores="'" + str(psutil.NUM_CPUS) +"'"  # psutil.cpu_count() - in newer versions
mysql_exec="update " + tableNM + " set value=" + cpu_cores + " where field_id='CPU_CORES'"
cursor.execute(mysql_exec)

RAM="'" + str(psutil.virtual_memory().total/(1000000000)) +"'"
mysql_exec="update " + tableNM + " set value=" + RAM + " where field_id='TOTAL_RAM'"
cursor.execute(mysql_exec)

secondary_drive="'"
sdb_drive=commands.getoutput("lsblk -d | grep 'sdb' | cut -d' ' -f1")

if not(sdb_drive==""):
    secondary_drive=secondary_drive + "/dev/sdb" +" "

sdc_drive=commands.getoutput("lsblk -d | grep 'sdc' | cut -d' ' -f1")
if not(sdc_drive==""):
    secondary_drive=secondary_drive + "/dev/sdc" +" "

sdd_drive=commands.getoutput("lsblk -d | grep 'sdd' | cut -d' ' -f1")
if not(sdd_drive==""):
    secondary_drive=secondary_drive + "/dev/sdd" +" "


secondary_drive=secondary_drive+"'"
mysql_exec="update " + tableNM + " set value=" + secondary_drive+ " where field_id='/dev/sdb /dev/sdc'"
cursor.execute(mysql_exec)

soc=zmq.Context().socket(zmq.REP)
soc.bind("tcp://0.0.0.0:6666")
msg=soc.recv_unicode()
soc.send_unicode(msg)
soc.close()

cursor.close()
conn.commit()
conn.close()
