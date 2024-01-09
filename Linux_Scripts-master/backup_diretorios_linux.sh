#!/bin/bash
#Responsavel: Jeferson Araujo
#Email: jefersonaraujo95@gmail.com

DATA=`date +%Y_%m_%d`
m=`findmnt /mnt/backup | wc -l`

if [ ! $m -eq 0 ]; then
# Dados do arquivo de backup
MAQUINA="NomeDoServidor"
ARQUIVO="backup-full-$MAQUINA-$DATA.tar.gz"
DIRETORIOS="/etc /bin /home /var/www"


# Cria o arquivo .tar.gz no /tmp (Temporáo)
cd /tmp
tar zcf /tmp/$ARQUIVO $DIRETORIOS

cp /tmp/$ARQUIVO /mnt/backup/$MAQUINA

Remove os arquivos temporarios
rm -f /tmp/$ARQUIVO
exit 1
else
hora=`date`
echo -e "Particao de Backup não montada. - $hora" >> /var/log/backup.log
fi
exit 0
