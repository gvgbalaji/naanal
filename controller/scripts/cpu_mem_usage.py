#! /usr/bin/python

import psutil
import MySQLdb
con = MySQLdb.connect("localhost","root","password","naanal")
cur=con.cursor()

cpu_usage=psutil.cpu_percent(interval=0.5)
mem=psutil.virtual_memory()
memory_usage=mem.percent

cur.execute("insert into cpu_mem_usage values(now(),%s,%s)"%(cpu_usage,memory_usage))
con.commit()
 
