#!/bin/bash

# ------------------------------------------------------- #
#
# Chinachu with Mirakurun Sleep Scripts - Uninstaller
#
# Copyright (c) 2016 tag
#
# ------------------------------------------------------- #

# ======================================================= #

function CheckRunAsRoot() {
	echo "checking this script is run as root..."
	if [ "$UID" -ne 0 ]
	then
		echo "error: please run as root." 1>&2
		exit 1
	fi
}

# ======================================================= #

echo
echo "# ------------------------------------------------------- #"
echo "#                                                         #"
echo "#   Chinachu with Mirakurun Sleep Scripts - Uninstaller   #"
echo "#                                                         #"
echo "#                                Copyright (c) 2016 tag   #"
echo "#                                                         #"
echo "# ------------------------------------------------------- #"
echo

# check evironment
CheckRunAsRoot

echo
echo "# ------------------------------------------------------- #"
echo

Config="/usr/local/etc/chinachu-mirakurun-ss/config"

if [ -f ${Config} ]
then
	source ${Config}

	echo "delete a lib directory:"
	if [ -d ${LibDir} ]
	then
		echo "deleting ${LibDir}"
		rm -rf ${LibDir}
	fi

	echo "delete a cron file:"
	if [ -f ${CronScript} ]
	then
		echo "deleting ${CronScript}"
		rm -f ${CronScript}
	fi

	echo "deleting symbolic links:"
	if [ -f ${PmUtilsScript} ]
	then
		echo "deleting ${PmUtilsScript}"
		rm -f ${PmUtilsScript}
	fi

	if [ -f ${SystemdScript} ]
	then
		echo "deleting ${SystemdScript}"
		rm -f ${SystemdScript}
	fi

	echo "deleting a configuration file:"
	rm -rf ${Config%/*}

	Mesg="operation is finished!"
	Stat=0
else
	Mesg="error: operation is aborted because configuration file is missing."
	Stat=1
fi

echo
echo "# ------------------------------------------------------- #"
echo
echo ${Mesg}
exit ${Stat}

# ======================================================= #
