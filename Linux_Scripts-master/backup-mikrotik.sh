#!/bin/bash

#Diretorio da Senha ou Senha. 
PASS=`cat /tmp/pf`
PORT=22
DATA=`date +%Y%m%d`
DIRETORIO="/home/mikrotik"

mkdir $DIRETORIOS/$DATA

for IP in `cat /tmp/rb-list`; do

        sshpass -p "$PASS" ssh -o StrictHostKeyChecking=no -p $PORT -l backup $IP '/export' > $DIRETORIO/$DATA/bkp-$IP.rsc  

done

#Necessario instalar o sshpass
#

