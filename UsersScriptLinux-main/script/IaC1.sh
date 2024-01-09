#!/bin/bash

echo "criando diretórios"

mkdir /publico
mkdir /adm
mkdir /ven
mkdir /sec

echo "criando grupo de usuarios"

groupadd GRP_PUB
groupadd GRP_ADM
groupadd GRP_VEN
groupadd GRP_SEC

echo "criando usuarios"

useradd rafael -m -s /bin/bash -p S0000 -G GRP_PUB,GRP_ADM
useradd luana -m -s /bin/bash -p S0000 -G GRP_PUB,GRP_ADM
useradd eduardo -m -s /bin/bash -p S0000 -G GRP_PUB,GRP_ADM

useradd mariana -m -s /bin/bash -p S0000 -G GRP_PUB,GRP_VEN
useradd roberto -m -s /bin/bash -p S0000 -G GRP_PUB,GRP_VEN
useradd juan -m -s /bin/bash -p S0000 -G GRP_PUB,GRP_VEN

useradd andre -m -s /bin/bash -p S0000 -G GRP_PUB,GRP_SEC
useradd julia -m -s /bin/bash -p S0000 -G GRP_PUB,GRP_SEC
useradd carlos -m -s /bin/bash -p S0000 -G GRP_PUB,GRP_SEC

echo "Atribuindo as permissões aos diretórios"

chown root:GRP_PUB /publico
chown root:GRP_ADM /adm
chown root:GRP_VEN /ven
chown root:GRP_SEC /sec

chmod 777 /publico
chmod 770 /adm
chmod 770 /ven
chmod 770 /sec


echo "Finalizando..."
echo "finalizado"
