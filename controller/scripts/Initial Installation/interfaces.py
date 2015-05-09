#!/usr/bin/python
import commands
import MySQLdb
import psutil
import os
import re

tableNM="initialconfig"
userNM="root"
passwrd="password"
hostIp="192.168.204.168"
dbName="naanal"
conn=MySQLdb.connect(hostIp,userNM,passwrd,dbName)
cursor=conn.cursor()
Wan= "'" + commands.getoutput("/sbin/ip -4 -o a | cut -d ' ' -f 2,7 | cut -d '/' -f1 | grep 192.168.204.168 | cut -d' ' -f1") +"'"
mysql_exec="update " + tableNM + " set paramValue=" + Wan + " where paramNM='WAN'"
cursor.execute(mysql_exec)

Lan= "'" +  commands.getoutput("/sbin/ip -4 -o a | cut -d ' ' -f 2,7 | cut -d '/' -f1 | grep 'eth0\|wlan'  | cut -d' ' -f1") +"'"
mysql_exec="update " + tableNM + " set paramValue=" + Lan + " where paramNM='LAN'"
cursor.execute(mysql_exec)

cpu_cores="'" + str(psutil.NUM_CPUS) +"'"  # psutil.cpu_count() - in newer versions
mysql_exec="update " + tableNM + " set paramValue=" + cpu_cores + " where paramNM='CPU_CORES'"
cursor.execute(mysql_exec)

RAM="'" + str(psutil.virtual_memory().total/(1000000000)) +"'"
mysql_exec="update " + tableNM + " set paramValue=" + RAM + " where paramNM='TOTAL_RAM'"
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
mysql_exec="update " + tableNM + " set paramValue=" + secondary_drive+ " where paramNM='HARD_DRIVES'"
cursor.execute(mysql_exec)




cursor.close()
conn.commit()
conn.close()
