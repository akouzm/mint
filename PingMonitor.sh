#!/bin/bash

#echo [$(ping -c 1 192.168.20.1 |grep time= |awk '{print $7}' | cut -f2 -d=)ms]
IP=192.168.20.1
#IP=192.168.20.222

Result=$(ping -w 1 -c 1 $IP |grep time= |awk '{print $7}' | cut -f2 -d=)

[[ ! -z $Result ]] && echo "[${Result}ms]"
[[ -z $Result ]] && echo TIMEOUT
