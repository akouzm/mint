#!/bin/bash

#echo [$(ping -c 1 192.168.20.1 |grep time= |awk '{print $7}' | cut -f2 -d=)ms]
GATEWAY=$(netstat -rn|grep "^0.0.0.0"|awk '{print $2}')

Result=$(ping -w 1 -c 1 $GATEWAY |grep time= |awk '{print $7}' | cut -f2 -d=)

[[ ! -z $Result ]] && echo "[${Result}ms]"
[[ -z $Result ]] && echo TIMEOUT
