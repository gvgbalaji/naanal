#!/bin/sh
for i in `virsh list --name --state-running`;do virsh shutdown $i && echo "Shutting Down $i";done;
