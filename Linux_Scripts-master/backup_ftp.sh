#!/bin/bash
#Responsavel: Jeferson Araujo
#Email: jefersonaraujo95@gmail.com
DATA=`date +%Y_%m_%d`

# Dados do arquivo de backup
MAQUINA="NomeDoServidor"
ARQUIVO="backup-full-$MAQUINA-$DATA.tar.gz"
DIRETORIOS="/etc /bin /home /var/www"

# Dados do servidor FTP
#nome ou ip do servidor ftp remoto ex : ftp.meudominio.com.br ou ip (192.168.50.1)
HOST_FTP="host"

USUARIO_FTP="USUARIO"
SENHA_FTP="SENHA"

# Cria o arquivo .tar.gz no /tmp (Temporáo)
cd /tmp
tar zcf /tmp/$ARQUIVO $DIRETORIOS

# Acessa o FTP e coloca os arquivos
ftp >> /dev/null -in << EOF
      open $HOST_FTP
      user "$USUARIO_FTP" "$SENHA_FTP"
      bin
      cd $MAQUINA
      send $ARQUIVO
      lcd /tmp
      put $ARQUIVO
      quit
EOF
# Remove os arquivos temporarios
rm -f /tmp/$ARQUIVO
