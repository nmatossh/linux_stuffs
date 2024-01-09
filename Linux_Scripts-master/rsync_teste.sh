#!/bin/bash
#Responsavel: Jeferson Araujo
#Email: jefersonaraujo95@gmail.com

DATA=`date`
backup="/BACKUP"
local=`findmnt $backup | wc -l`
# Dados do arquivo de backup
DIRETORIO="/tmp/"
#O local esta montado ?
if [ ! $local -eq 0 ]; then
#caso sim
#rsync basic
rsync -ruv $DIRETORIO $backup
echo -e "Realizando backup. - $DATA" >> /var/log/backup.log

exit 1
else

echo -e "Particao de Backup não montada. - $DATA" >> /var/log/backup.log
fi
exit 0
