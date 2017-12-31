#!/bin/bash

# ------------------------------------------------------- #
#
# reload-pt3_drv.sh
#
# Copyright (c) 2018 tag
#
# ------------------------------------------------------- #

mirakurun stop
sleep 10
modprobe -r pt3_drv
modprobe pt3_drv
mirakurun start
