#!/bin/bash
#Responsavel: Jeferson Araujo
#Email: jefersonaraujo95@gmail.com

DATA=`date +%Y_%m_%d`

# Dados do arquivo de backup
MAQUINA="NomeDoServidor"
ARQUIVO="backup-full-$MAQUINA-$DATA.tar.gz"
DIRETORIOS="/etc /bin /home /var/www /opt"
#Script realiza apenas backup de arquivos modificados 

# Cria o arquivo .tar.gz no /tmp (Temporario)
cd /tmp
find $DIRETORIOS -mtime -1 -type f -print | \
tar zcf /tmp/$ARQUIVO -T -

cp /tmp/$ARQUIVO /mnt/backup

# Remove os arquivos temporarios
rm -f /tmp/$ARQUIVO
