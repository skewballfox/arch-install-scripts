# ask user if they want to zero out drive
# if yes zero out and recreate partition scheme

#if no assume drive has been already set up

timedatectl set-ntp true
pacstrap /mnt base-devel

cp -r arch-install-scripts /mnt
arch-chroot /mnt arch-install-scripts/arch-post-chroot.sh


#unmount all and reboot