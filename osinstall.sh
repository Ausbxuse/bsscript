#!/bin/sh

mount /dev/sda2 /mnt || exit 1
mkdir /mnt/boot || exit 1
mkdir /mnt/home || exit 1
mount /dev/sda1 /mnt/boot || exit 1
mount /dev/sda3 /mnt/home || exit 1
basestrap /mnt base base-devel linux linux-firmware neovim runit elogind-runit #nocomfirm || exit 1
fstabgen -U /mnt >> /mnt/etc/fstab || exit 1
artix-chroot /mnt || exit 1
ln -sf /usr/share/zoneinfo/America/Los_Angeles /etc/localtime || exit 1
hwclock --systohc || exit 1
echo -e "en_US.UTF-8 UTF-8\nen_US ISO-8859-1" >> /etc/locale.gen || exit 1
locale-gen || exit 1
echo -e 'export LANG="en_US.UTF-8"\nexport LC_COLLATE="C"' || exit 1
echo $hostname > /etc/hostname || exit 1
echo -e "127.0.0.1     localhost\n::1     localhost\n127.0.1.1      $hostname.localdomain $hostname" || exit 1
pacman -S grub efibootmgr networkmanager networkmanager-runit || exit 1
ln -s /etc/runit/sv/NetworkManager /etc/runit/runsvdir/default #?? can be very wrong here || exit 1
passwd || exit 1
