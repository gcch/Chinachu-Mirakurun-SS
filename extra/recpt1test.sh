#!/bin/bash

# ------------------------------------------------------- #
#
# recpt1test.sh
#
# Copyright (c) 2016 tag
#
# ------------------------------------------------------- #

Cmd=recpt1
Opt=--b25
Length=10
OutputDir=.

set -x

# /dev/pt3video0 - BS
${Cmd} ${Opt} --device /dev/pt3video0 --strip 101 ${Length} ${OutputDir}/${Cmd}test_bs_pt3video0.ts

# /dev/pt3video1 - BS
${Cmd} ${Opt} --device /dev/pt3video1 --strip 101 ${Length} ${OutputDir}/${Cmd}test_bs_pt3video1.ts

# /dev/pt3video0 - CS
#${Cmd} ${Opt} --device /dev/pt3video0 --strip 55 ${Length} ${OutputDir}/${Cmd}test_cs_pt3video0.ts

# /dev/pt3video1 - CS
#${Cmd} ${Opt} --device /dev/pt3video1 --strip 55 ${Length} ${OutputDir}/${Cmd}test_cs_pt3video1.ts

# /dev/pt3video2
${Cmd} ${Opt} --device /dev/pt3video2 --strip 27 ${Length} ${OutputDir}/${Cmd}test_gr_pt3video2.ts

# /dev/pt3video3
${Cmd} ${Opt} --device /dev/pt3video3 --strip 27 ${Length} ${OutputDir}/${Cmd}test_gr_pt3video3.ts

set +x
