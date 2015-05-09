#!/usr/bin/python
import commands
import MySQLdb
tableNM="initialconfig"
userNM="root"
passwrd="password"
hostIp="192.168.204.168"
dbName="naanal"
conn=MySQLdb.connect(hostIp,userNM,passwrd,dbName)
cursor=conn.cursor()
Wan= "'" + commands.getoutput("/sbin/ip -4 -o a | cut -d ' ' -f 2,7 | cut -d '/' -f1 | grep 192.168.204.168 | cut -d' ' -f1") +"'"
Lan= "'" +  commands.getoutput("/sbin/ip -4 -o a | cut -d ' ' -f 2,7 | cut -d '/' -f1 | grep 'eth0\|wlan'  | cut -d' ' -f1") +"'"
mysql_exec="update " + tableNM + " set paramValue=" + Wan + " where paramNM='WAN'"
cursor.execute(mysql_exec)

mysql_exec="update " + tableNM + " set paramValue=" + Lan + " where paramNM='LAN'"
cursor.execute(mysql_exec)

cursor.close()
conn.commit()
conn.close()
