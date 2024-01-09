#EXECUTE THIS AFTER CHROOTING INTO THE W.I.P. SYSTEM!

#Install dhcpcd otherwhise we will not have net lol
pacman -S --noconfirm dhcpcd

systemctl enable dhcpcd

#Set the time zone
ln -sf /usr/share/zoneinfo/Region/City /etc/localtime

#Generate /etc/adjtime
hwclock --systohc

#Create the locale.gen file, remove if it already exists and create it again with cat
if [ -f /etc/locale.gen ]; then
  rm -i /etc/locale.gen
fi
cat > /etc/locale.gen << "EOF"
en_US.UTF-8 UTF-8
EOF

#Generate the locales for en_US.UTF-8
locale-gen

#Create the hostname file & hosts file
cat > /etc/hostname << "EOF"
mijailsArch
EOF

cat > /etc/hosts << "EOF"
127.0.0.1	localhost
::1       localhost
127.0.1.1	mijailsArch.localdomain	mijailsArch
EOF

#Create an initramfs
mkinitcpio -P

pacman -S --noconfirm grub

grub-install --target=i386-pc /dev/sda

grub-mkconfig -o /boot/grub/grub.cfg

passwd #CANT LOGIN WITHOUT A PASSWORD
