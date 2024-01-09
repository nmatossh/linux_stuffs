#!/bin/bash
main(){
	finish=0
	sudo clear
	echo
	sudo apt-get install neofetch
	sudo apt-get update
	sudo clear
	sudo neofetch
	echo
	sudo lspci -k | grep amdgpu
	echo

	while [ $finish = 0 ];
	do
		echo "	> Instalar repositório PPA?"
		echo "	1 - AMD		2 - NVIDIA		3 - JÁ INSTALADO"
		read opcao;
		case $opcao in
			"1") 
				sudo apt-add-repository ppa:oibaf/graphics-drivers
				sudo apt-get update
				sudo apt-get dist-upgrade
				echo
				echo "	> É necessário a reinicialização do computador para continuar!"
				echo "	> Script finalizado!"
				echo
				exit 0
			;;
			"2")
				sudo apt-add-repository ppa:graphics-drivers/ppa
				sudo apt update
				sudo ubuntu-drivers autoinstall
				echo
				echo "	> Driver instaldo"
				echo "	> É necessário a reinicialização do computador!"
				echo "	> Script finalizado!"
				echo
				exit 0
			;;
			"3")
				echo "	> Continuando..."
			;;
		esac
		echo
		echo "	> Ativar driver AMD ou INTEL?"
		read driver1;
		driver2=${driver1,,}
		grub
	done
echo "	> Substituindo arquivo..."
sudo mv grub /etc/default/grub && sudo grub2-mkconfig -o /boot/grub2/grub.cfg && sudo grub-mkconfig -o /boot/grub/grub.cfg
echo "	> Salvando arquivo..."
echo
sudo update-grub
echo
echo "	> É necessário a reinicialização do computador!"
echo "	> Script finalizado!"
echo
}

grub()
{
	echo "	> Criando arquivo..."
 echo "# If you change this file, run 'update-grub' afterwards to update
# /boot/grub/grub.cfg.
# For full documentation of the options in this file, see:
#   info -f grub -n 'Simple configuration'

GRUB_DEFAULT=0
GRUB_TIMEOUT_STYLE=hidden
GRUB_TIMEOUT=10
GRUB_DISTRIBUTOR=`lsb_release -i -s 2> /dev/null || echo Debian`
GRUB_CMDLINE_LINUX_DEFAULT='quiet splash'" >> grub

if [ $driver2 = "amd" ];
then
	echo "GRUB_CMDLINE_LINUX='radeon.cik_support=0 amdgpu.cik_support=1 radeon.si_support=0 amdgpu.si_support=1'" >> grub
	finish=1
elif [ $driver2 = "intel" ];
	then
		echo "GRUB_CMDLINE_LINUX=''" >> grub
		finish=1
	else
		echo
		echo "	> Comando inválido!"
		echo
fi
echo >> grub
echo "# Uncomment to enable BadRAM filtering, modify to suit your needs
# This works with Linux (no patch required) and with any kernel that obtains
# the memory map information from GRUB (GNU Mach, kernel of FreeBSD ...)
#GRUB_BADRAM='0x01234567,0xfefefefe,0x89abcdef,0xefefefef'

# Uncomment to disable graphical terminal (grub-pc only)
#GRUB_TERMINAL=console

# The resolution used on graphical terminal
# note that you can use only modes which your graphic card supports via VBE
# you can see them in real GRUB with the command 'vbeinfo'
#GRUB_GFXMODE=640x480

# Uncomment if you don't want GRUB to pass 'root=UUID=xxx' parameter to Linux
#GRUB_DISABLE_LINUX_UUID=true

# Uncomment to disable generation of recovery mode menu entries
#GRUB_DISABLE_RECOVERY='true'

# Uncomment to get a beep at grub start
#GRUB_INIT_TUNE='480 440 1'" >> grub
}
main
