#!/usr/bin/python
import zmq
soc=zmq.Context().socket(zmq.REQ)
soc.connect("tcp://192.168.1.230:6666")
soc.send_unicode("OK")
soc.recv_unicode()
soc.close()
