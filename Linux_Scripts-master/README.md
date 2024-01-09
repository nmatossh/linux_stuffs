# Linux_Scripts

#### Diversos Scripts Criados ou otimizados por mim para manutenção ou otimizção de Servidores Linux e Unix Edit

## Simulados LPIC
http://virtx.com.br/simulado/simulado-lpi-treinamento-linux/lpic-ingles/
https://www.exam-labs.com/exam/LX0-103


# DICA :
Ver status das Interfaces:
###  ip addr show

Adicionar o IP  10.0.0.10 á interface ens192;
###  ip addr add 10.0.0.10/8 dev ens192

Você pode utilizar o comando “ip route” para adicionar o gateway:

Adiciona 10.0.0.1 como gateway:
###  ip route add default via 10.0.0.1 dev ens192

Por fim, não se esqueça de configurar o DNS:
###  echo “nameserver 8.8.8.8” >> /etc/resolv.conf

Muito provavelmente, as configurações realizadas “na mão” serão rapidamente “desfeitas” pelo NetworkManager. Você pode removê-lo (por sua conta em risco):

### `yum -y remove NetworkManager`
