#! /bin/bash

for ip in $(cat MiningServerIPList.txt);do

#echo $ip
iptables -A INPUT -s $ip -j DROP



done
