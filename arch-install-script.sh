timedatectl set-ntp true
pacstrap /mnt base-devel

cp -r arch-install-scripts /mnt
arch-chroot /mnt arch-install-scripts/arch-post-chroot.sh
