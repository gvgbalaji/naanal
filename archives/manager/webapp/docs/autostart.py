#! /usr/bin/python
import MySQLdb
from novaclient import client as novaclient
from variables import *

nova = novaclient.Client(2,OS_USER,OS_PASS,OS_TENANT,OS_AUTH_URL)

con = MySQLdb.connect(MYSQL_IP,MYSQL_USER,MYSQL_PASS)
cur = con.cursor()

cur.execute("select instance from naanal.custom_setting where autostart=1")

for ins in cur.fetchall():
	print "Instance "+ ins[0] + " is Starting"
	try:
		nova.servers.find(name=ins[0]).start()
	except novaclient.exceptions.Conflict,e:
		print e


cur.close()
