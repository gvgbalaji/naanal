#! /usr/bin/python

import MySQLdb
import os
from variables import *
from novaclient import client as novaclient
import time

operation = os.sys.argv[1]
#operation = "sample"
print operation
nova = novaclient.Client(2,OS_USER,OS_PASS,OS_TENANT,OS_AUTH_URL)

con = MySQLdb.connect(MYSQL_IP,MYSQL_USER,MYSQL_PASS)
cur=con.cursor()

cur.execute("select id,display_name from nova.instances where power_state=1 and deleted=0")

for ins in cur.fetchall():
	print "Instance %s is Powering-off"%(ins[1])
	os.system("virsh shutdown instance-%08x"%ins[0])
	#print("virsh shutdown instance-%08x"%ins[0])
	print "Successfully Shutdown"
	
#time.sleep(60)
cur.close()

if(operation=="shutdown"):
	#os.system("shutdown -P 1 ")
	os.system("at -f shut.sh now+1minutes")
elif(operation=="reboot"):	
	#os.system("shutdown -r 1 ")
	os.system("at -f rebo.sh now+1minutes")
