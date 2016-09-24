#!/bin/bash

# ------------------------------------------------------- #
#
# update-mirakurun
#
# Copyright (c) 2016 tag
#
# ------------------------------------------------------- #

function CheckRunAsRoot {
	echo "checking this script is run as root..."
	if [ "$UID" -ne 0 ]; then
		echo "error: please run as root." 1>&2
		exit 1
	fi
}

# Check run as root
CheckRunAsRoot

# Update Mirakurun and Rivarun
set -x
mirakurun stop
npm install rivarun@latest -g --production
npm install mirakurun@latest -g --unsafe --production
mirakurun start
set +x
