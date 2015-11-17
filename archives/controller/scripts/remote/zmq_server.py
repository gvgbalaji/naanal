#!/usr/bin/python
import zmq
import os
ctx = zmq.Context()
soc = ctx.socket(zmq.REP)
soc.bind("tcp://0.0.0.0:5555")
while(1):
	msg=soc.recv_json()
	fn = msg['fn']
	rep=""
	if(fn=='shell'):
		rep=os.popen(msg['cmd']).read()
	elif(fn=='power'):
		os.system("/opt/naanal/controller/scripts/remote/host_shut.sh %s"%msg['sub_fn'])
	else:
		pass
	soc.send_unicode(rep)	
