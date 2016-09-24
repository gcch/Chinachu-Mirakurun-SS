#!/bin/bash

# ------------------------------------------------------- #
#
# rivaruntest.sh
#
# Copyright (c) 2016 tag
#
# ------------------------------------------------------- #

Cmd=rivarun
Opt=--b25
Length=10
OutputDir=.

set -x

# GR test: NHK G (Tokyo)
${Cmd} ${Opt} --sid 1024 --ch GR/27 ${Length} ${OutputDir}/${Cmd}test_gr.ts

# BS test: NHK BS1
${Cmd} ${Opt} --sid 101 --ch BS/BS15_0 ${Length} ${OutputDir}/${Cmd}test_bs.ts

# CS test: Shop Channel
${Cmd} ${Opt} --sid 55 --ch CS/CS8 ${Length} ${OutputDir}/${Cmd}test_cs.ts

set +x
