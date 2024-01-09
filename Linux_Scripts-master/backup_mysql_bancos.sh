#!/bin/bash
#Responsavel: Jeferson Araujo
#Email: jefersonaraujo95@gmail.com
# Definindo a Data
DATA=`date +%Y-%m-%d`
MAQUINA="ads"
ARQUIVO="backup_bancos_$MAQUINA-$DATA.tar.gz"
DIRETORIO="/var/backup/mysql/"
USER="USUARIO"
PASS="SENHA"
# Gerando a lista de todos os bancos
mysql -u$USER -p$PASS -e "show databases;" > /tmp/bancos

# Gerando backup dos bancos
for i in `cat /tmp/bancos`
do
        # Gerando Backup do Banco
        nice -n +19 mysqldump -u$USER -p$PASS $i > $DIRETORIO$i.sql
        #nice define o nivel de prioridade do processo.
done
# Compacta Arquivo de Backup
cd $DIRETORIO
tar -pzcf $ARQUIVO *.sql

#copia para storage remoto
cp $ARQUIVO /mnt/backup/$MAQUINA

# Apaga Arquivo SQL
rm -f *.sql
