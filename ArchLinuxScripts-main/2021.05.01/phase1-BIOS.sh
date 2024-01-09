#EXECUTE THIS AFTER PARTITIONING THE SYSTEM LIKE THIS LAYOUT:
#/dev/sda  = disk
#/dev/sda1 = swap
#/dev/sda2 = root

mkswap /dev/sda1
mkfs.ext4 /dev/sda2

#Friendly reminder: /dev/sda2 is root if you didnt read that warning up there
mount /dev/sda2 /mnt

swapon /dev/sda1

pacstrap /mnt base linux linux-firmware curl wget

genfstab -U /mnt >> /mnt/etc/fstab

arch-chroot /mnt
