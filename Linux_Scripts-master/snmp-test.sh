#!/bin/bash
#Responsavel: Jeferson Araujo
#Email: jefersonaraujo95@gmail.com

comu=$1; host=$2; port=$3
snmpstatus -v 1 -c $comu $host:$port >/dev/null 2>&1
if [ ! $? -eq 0 ]; then
echo -e "FALHA"
exit 1
else
echo -e "OK"
fi
exit 0
