#! /usr/bin/python

import MySQLdb
import os
from variables import *
from novaclient import client as novaclient

operation = os.sys.argv[1]
print operation
nova = novaclient.Client(2,OS_USER,OS_PASS,OS_TENANT,OS_AUTH_URL)

con = MySQLdb.connect(MYSQL_IP,MYSQL_USER,MYSQL_PASS)
cur=con.cursor()

cur.execute("select id,display_name,os_type from nova.instances where power_state=1 and deleted=0")

for ins in cur.fetchall():
	print "Instance %s is Powering-off"%(ins[1])
	if(ins[2]== None):
		nova.servers.find(name=ins[1]).stop()
		print "Successfully Stopped"
	else:
		os.system("virsh shutdown instance-%08x"%ins[0])
		#print("virsh shutdown instance-%08x"%ins[0])
		print "Successfully Shutdown"
	

cur.close()

if(operation=="shutdown"):
	os.system("shutdown -P 1 ")
elif(operation=="reboot"):
	os.system("shutdown -r 1 ")
