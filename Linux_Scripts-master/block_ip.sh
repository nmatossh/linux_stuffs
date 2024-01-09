#! /bin/bash

for ip in $(cat lista.txt);do

#echo $ip
iptables -A INPUT -s $ip -j DROP

done
