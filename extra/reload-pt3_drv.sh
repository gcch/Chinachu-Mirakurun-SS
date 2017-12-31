#!/bin/bash

# ------------------------------------------------------- #
#
# reload-pt3_drv.sh
#
# Copyright (c) 2018 tag
#
# ------------------------------------------------------- #

function StopRecpt1() {
	sleep 2s	
	for pid in $(ps aux | grep -v grep | grep recpt1 | awk '{print $2}'); do
			kill -9 $pid
	done
	sleep 2s
}

# ======================================================= #

mirakurun stop
StopRecpt1
modprobe -r pt3_drv
modprobe pt3_drv
mirakurun start
