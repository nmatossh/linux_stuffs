#!/bin/bash

# Nome do arquivo: limpezaBackup.sh

#

# Script que realiza limpeza dos backups antigos

# 

# Versão 1.0: Configurado comando para gerar arquivo com a lista de nomes dos arquivos antigos 

# Versão 1.1: Incluido o comando para remover os arquvios antigos 

# Versão 1.2: Incluido o menu de ajuda e versao 

# Versão 1.3: Incluido variavel para tornar o script universal 

#

#########################################

# Feito por: Marcello Marafioti         #

# Data: 16/11/2018                      #

# e-mail: marcellomarafioti@hotmail.com #

#########################################

#

#



MENSAGEM_USO="

Uso: $(basename "$0") [-h | -v]


  -h, --help        Mostra esta tela de ajuda e sai

  -v, --version     Mostra a versao do programa e sai


###### MODO DE USO DO SCRIPT ######

1 - Editar os campos: DIR ( diretorio onde fica os arquivos a serem analisados )

                      ARQ ( nome do arquivo que vai constar a lista de nomes a serem apagados )

       DIAS ( configurar o numero de dias de retencao )        

2 - Executar o script depois de ter editado os campos mencionado no item 1

Obeservacoes: fazer um backup antes de rodar este script pela primeira vez 

              configurar o script , realizar o backup e executar o script 


###################################

"


# Tratamento das opções de linha de comando

case "$1" in

-h | --help)

 echo "$MENSAGEM_USO"

 exit 0

;;


-v | --version)

 echo -n $(basename "$0")

 # Extrai a versão diretamente dos cabeçalhos do programa

 grep '^# Versão ' "$0" | tail -1 | cut -d : -f 1 | tr -d \#

 exit 0

;;


*)

 if test -n "$1"

 then

  echo Opção inválida: $1

  exit 1

 fi

;;

esac


# Processamento do script 

### Entrada do script ##

echo Para obter ajuda execute ./limpezaBackup.sh -h

echo

echo "#############################################"

echo


### Diretorio onde esta os arquivos para serem apagados ###

DIR=/teste/limpeza/


### Arquivo que contem os nomes dos arquivos a serem apagados ###

ARQ=arquivosVelhos.txt


### Configuracao de quantos dias vao ser ignorados para exclusao ##

DIAS=+3


### Comando que localiza e gera uma lista de arquivos a serem apagados ###

#find /teste/limpeza/ -mtime +3 > arquivosVelhos.txt

find $DIR -mtime $DIAS  > $ARQ


### Aqui tem um sleep para ele segurar 1 segundo para executar o comando de limpeza ###

sleep 1


### Comando que apaga os arquivos da lista ###

#xargs -t -L1 rm -f < arquivosVelhos.txt

xargs -t -L1 rm -f < $ARQ 
