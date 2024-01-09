#!/bin/bash
IFNET="eno1"

# como nem todas distros tem o iproute2 é necessário usar o ifconfig também para retrocompatibilidade...
# no caso testamos se há o comando ip caso haja, usamos o comando ip addr show para filtrar o ip, caso não haja usamos o ifconfig
IP=$(if type ip > /dev/null 2>&1; then ip addr show $IFNET | awk '/inet/ {print $2}' | paste -s -d,; else ifconfig wlan0 | awk '/inet/ {print $2 "/" $4 }' | paste -s -d,; fi)


cat <<FIM
===============
Geral
===============
Nro proc:	`cat /proc/cpuinfo | grep processor | wc -l`
Mem (MB):	`free -m | grep Mem | awk '{print $2}'`
Tam disco:	`fdisk -l | grep -i '^dis\(co\|k\) /'| cut -d' '  -f 2-`
Distro:		`lsb_release -d | cut -f 2-`
Versão Kernel:	`uname -r`
Usuários:	`cat /etc/passwd | awk -F: '( $3 > 999 ) { print $1 }' |  wc -l` (`cat /etc/passwd | awk -F: '( $3 > 999 ) { print $1 }' | paste -s -d,`)
Particionamento: 
`df -h | grep -i 'Sist\|^\/dev'`
Uptime:		`uptime | awk '{print $3,$4}' | cut -d, -f1`
Load Average:	`uptime | awk '{print $(NF-2), $(NF-1), $(NF)}'`
Tamanho logs:	`du -sh /var/log | cut -f1`
===============
Rede
===============
Hostname:	`hostname`
End. IP:	`echo $IP`
Gateway padrão:	`route -n | grep '^0.0.0.0' | awk '{print $2}'`
Serv. DNS:	`cat /etc/resolv.conf | grep 'nameserver' | cut -d' ' -f 2 | paste -s -d,`
===============
Serviços
===============
`netstat -ntlp`
FIM
