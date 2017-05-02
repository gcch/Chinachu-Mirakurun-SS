#!/bin/bash

# ------------------------------------------------------- #
#
# recordedCommand.sh
# --- sending a recorded result by Gmail (experimental)
#
# Copyright (c) 2017 tag. All rights reserved.
#
# needed packages: mailx (Heirloom mailx), jq, curl
#
# prepare:
# + add google ca to db
#   $ CertDir=~/.pki/nssdb/
#   $ CertName=~/gmail.crt
#   $ echo -n | openssl s_client -connect smtp.gmail.com:465 | \
#       sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > ${CertName}
#   $ certutil -A -n "Google Internet Authority" \
#       -t "C,," -d ${CertDir} -i ${CertName}
#   $ rm ${CertName}
#   [ref: http://colibri.sblo.jp/article/103423197.html]
#
# + generate Gmail account password
#   [ref: https://support.google.com/accounts/answer/185833]
#
# + set parameters
#   MailUser, MailPasswd, From, To, NssDbDir, ...
#
# ------------------------------------------------------- #

export LC_CTYPE=ja_JP.UTF-8

# settings
MailUser="username@gmail.com"
MailPasswd="password"
Smtp="smtp://smtp.gmail.com:587"
From="${MailUser}"
To="${MailUser}"
NssDbDir="~chinachu/.pki/nssdb/"

# get the next reserved program infomation
Next="$(curl -s http://$(hostname):20772/api/reserves.json | jq .[1])"

# subject of mail
Subject="[$(hostname): recorded] $(echo ${2} | jq -r ".fullTitle")"

# body of mail (recorded program infomation and next program infomation)
Body=$(cat << EOS
----- program info -----
category:  $(echo ${2} | jq -r ".category")
channel:   $(echo ${2} | jq -r ".channel.name") ($(echo ${2} | jq -r ".channel.type")$(echo ${2} | jq -r ".channel.channel"))
onairtime: $(date --date "@$(($(echo ${2} | jq -r ".start") / 1000))") -- $(date --date "@$(($(echo ${2} | jq -r ".end") / 1000))")
fulltitle: $(echo ${2} | jq -r ".fullTitle")
file:      $(ls -la "${1}")

----- next program info -----
category:  $(echo ${Next} | jq -r ".category")
channel:   $(echo ${Next} | jq -r ".channel.name") ($(echo ${Next} | jq -r ".channel.type")$(echo ${Next} | jq -r ".channel.channel"))
onairtime: $(date --date "@$(($(echo ${Next} | jq -r ".start") / 1000))") -- $(date --date "@$(($(echo ${Next} | jq -r ".end") / 1000))")
fulltitle: $(echo ${Next} | jq -r ".fullTitle")
EOS
)

# create an attached file which is written about the system running Chinachu
SystemInfo="/tmp/systeminfo.txt"
cat << EOS > "${SystemInfo}"
date:
$(date)

uname:
$(uname -a)

uptime:
$(uptime)

login users:
$(who)

ram:
$(free)

disk:
$(df)

tuners:
$(ls -la /dev/pt3video*)
EOS

# create an attached file which is written about the detail of recorded program
ProgramId=$(echo ${2} | jq -r ".id")
Attached="/tmp/${ProgramId}_detail.txt"
echo ${2} | jq -r ".detail" > "${Attached}"

# send a mail
echo "${Body}" | mailx -v -s "$(echo ${Subject})" \
	-S smtp="${Smtp}" \
	-S smtp-auth=login \
	-S smtp-auth-user="${MailUser}" \
	-S smtp-auth-password="${MailPasswd}" \
	-S smtp-use-starttls \
	-S from="${MailUser}" \
	-S nss-config-dir="${NssDbDir}" \
	-S ssl-verify=ignore \
	-a "${Attached}" \
	-a "${SystemInfo}" \
	${To}

rm -f "${SystemInfo}" "${Attached}"

exit
