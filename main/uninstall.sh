#!/bin/bash

# ------------------------------------------------------- #
#
# Chinachu with Mirakurun Sleep Scripts - Uninstaller
#
# Copyright (c) 2016-2017 tag
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
echo "#                           Copyright (c) 2016-2017 tag   #"
echo "#                                                         #"
echo "# ------------------------------------------------------- #"
echo

# check evironment
CheckRunAsRoot

echo
echo "# ------------------------------------------------------- #"
echo

CompList="/usr/local/etc/chinachu-mirakurun-ss/components"

if [ -f "${CompList}" ]
then
	source "${CompList}"

	echo "delete a lib directory:"
	if [ -d "${LibDir}" ]
	then
		echo "deleting ${LibDir}"
		rm -rf "${LibDir}"
	fi

	echo "delete a cron file:"
	if [ -f "${CronScript}" ]
	then
		echo "deleting ${CronScript}"
		rm -f "${CronScript}"
	fi
	
	echo "detete scripts for power management utilities:"
	if [ -f "${PmUtilsScript}" ]
	then
		echo "deleting ${PmUtilsScript}"
		rm -f "${PmUtilsScript}"
	fi
	if [ -f "${SystemdScript}" ]
	then
		echo "deleting ${SystemdScript}"
		rm -f "${SystemdScript}"
	fi

	echo "deleting symbolic links for power management utilities (previous version support):"
	if [ -h "${PmUtilsScript}" ]
	then
		echo "deleting ${PmUtilsScript}"
		rm -f "${PmUtilsScript}"
	fi
	if [ -h "${SystemdScript}" ]
	then
		echo "deleting ${SystemdScript}"
		rm -f "${SystemdScript}"
	fi

	echo "deleting a configuration directory:"
	if [ -d "${EtcDir}" ]
	then
		echo "deleting ${EtcDir}"
		rm -rf "${EtcDir}"
	fi

	echo "deleting a temporary file:"
	if [ -f "${TmpFile}" ]
	then
		echo "deleting ${TmpFile}"
		rm -rf "${TmpFile}"
	fi

	echo "deleting a log file:"
	if [ -f "${LogFile}" ]
	then
		echo "deleting ${LogFile}"
		rm -rf "${LogFile}"
	fi
	if [ -f "${LogFileOld}" ]
	then
		echo "deleting ${LogFileOld}"
		rm -rf "${LogFileOld}"
	fi

	Mesg="operation is finished!"
	Stat=0
else
	Mesg="error: operation is aborted because components list file is missing."
	Stat=1
fi

echo
echo "# ------------------------------------------------------- #"
echo
echo ${Mesg}
exit ${Stat}

# ======================================================= #
