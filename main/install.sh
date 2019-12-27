#!/bin/bash

# ------------------------------------------------------- #
#
# Chinachu with Mirakurun Sleep Scripts - Installer
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

function CreateAndImportConfig() {
	echo "setup configuration:"

	Prefix="/usr/local"
	ProjectName="chinachu-mirakurun-ss"
	ConfigFile="${Prefix}/etc/${ProjectName}/config"
	ComponentsListFile="${Prefix}/etc/${ProjectName}/components"

	# check to exist the directory
	if [ ! -d ${ConfigFile%/*} ]
	then
		echo "creating a configuration directory..."
		mkdir -p ${ConfigFile%/*}
	fi

	# check to exist the config file
	if [ ! -f ${ConfigFile} ]
	then
		echo "creating a configuration file..."
		cp ./etc/config ${ConfigFile%/*}
	fi

	# import the config file
	source ${ConfigFile}

	# copy and import the components list file
	cp -f ./etc/components ${ComponentsListFile} 
	source ${ComponentsListFile}

	echo
}

# ======================================================= #

function CopyLibs() {
	echo "setup libraries:"

	if [ ! -d ${LibDir} ]
	then
		mkdir -p ${LibDir}
	fi

	for F in `ls ./lib`
	do
		echo "copying \`${F}'..."
		cp "./lib/${F}" "${LibDir}/${F}"
		chmod +x "${LibDir}/${F}"
	done

	echo
}

# ------------------------------------------------------- #

function LinkPowerManagerScript() {
	echo "setup power manager:"

	if [ -e ${PmUtilsScript} ]
	then
		echo "deleting a script for pm-utils..."
		rm -f "${PmUtilsScript}"
	fi
	
	if [ -e ${SystemdScript} ]
	then
		echo "deleting a script for systemd..."
		rm -f ${SystemdScript}
	fi

	if [ -d ${PmUtilsScript%/*} ]
	then
		echo "linking to script for pm-utils..."
		echo -e "#!/bin/bash\n${LibDir}/chinachu-mirakurun-sleep \${1} >>${LogFile} 2>&1" >"${PmUtilsScript}"
		chmod +x "${PmUtilsScript%}"
	fi

	if [ -d ${SystemdScript%/*} ]
	then
		echo "linking to script for systemd..."
		echo -e "#!/bin/bash\n${LibDir}/chinachu-mirakurun-sleep \${1} \${2} >>${LogFile} 2>&1" >"${SystemdScript}"
		chmod +x "${SystemdScript}"
	fi

	echo
}

# ======================================================= #

function SetupCron() {
	echo "setup cron for sleep:"

	# delete a cron file if it exists
	if [ -f ${CronScript} ]
	then
		echo "deleting an old cron file..."
		rm -f ${CronScript}
	fi

	# copy a cron file
	echo "creating an cron base file..."
	cp ./cron/chinachu-mirakurun-ss-cron ${CronScript}

	# write a cron schedule
	declare CronLogRotateEntry="0 0 * * * root [[ \`wc -l ${LogFile} | cut -d ' ' -f1\` -ge 1000 ]] && cat ${LogFile} >${LogFileOld} && echo -n >${LogFile}"
	echo "writing a cron job..."
	echo "${CronLogRotateEntry}" >>"${CronScript}"
	declare CronEntry="2-59/${CheckPeriod} * * * * root ${ChinachuCheckStatus} >>${LogFile} 2>&1 && sleep 10 && ${ShiftToSleep} >>${LogFile} 2>&1"
	echo "writing a cron job..."
	echo "${CronEntry}" >>"${CronScript}"

	echo
}

# ------------------------------------------------------- #

function RestartCron() {
	echo "restart cron daemon:"

	InitSystem=`ps -p 1 | tail -n 1 | tr -s " " " " | sed "s/^[ ]*//" | cut -d " " -f 4`
	OsName=`cat /etc/os-release | grep "^NAME=" |  cat /etc/os-release | grep "^NAME=" | cut -d "=" -f 2 | tr -d "\""`

	case ${InitSystem##*/} in
	init)
		# for SysVinit / Upstart
		if [ -f /etc/rc.d/init.d/crond ]
		then
			/etc/rc.d/in.d/crond restart
		elif [ -f /etc/init.d/crond ]
		then
			# for Debian (?)
			/etc/init.d/crond restart
		elif [ -f /etc/init.d/cron ]
		then
			# for Ubuntu
			/etc/init.d/cron restart
		fi	 
		;;
	systemd)
		# for systemd
		# for RHEL / CentOS
		if [ -f /etc/systemd/system/*/crond.service ]
		then
			systemctl restart crond.service
		# for Debian
		elif [ -f /etc/systemd/system/*/cron.service ]
			systemctl restart cron.service
		fi
		;;
	esac

	if (( $? != 0 ))
	then
		echo "error: please restart crond by yourself." 1>&2
	fi

	echo
}

# ======================================================= #


# ======================================================= #

echo
echo "# ------------------------------------------------------- #"
echo "#                                                         #"
echo "#    Chinachu with Mirakurun Sleep Scripts - Installer    #"
echo "#                                                         #"
echo "#                          Copyright (c) 2016-2017 tag    #"
echo "#                                                         #"
echo "# ------------------------------------------------------- #"
echo

# check evironment
CheckRunAsRoot
CreateAndImportConfig

# grant permission
chmod +x ./uninstall.sh

echo
echo "# ------------------------------------------------------- #"
echo

CopyLibs
LinkPowerManagerScript

SetupCron
RestartCron

echo
echo "# ------------------------------------------------------- #"
echo
echo "Installation is finished."
exit 0

# ======================================================= #
