# ask user if they want to zero out drive
########################### Partition management #################
##################################################################

# if yes zero out and recreate partition scheme

#if no assume drive has been already set up



########################### Begin Install ########################
##################################################################

timedatectl set-ntp true

#creating the base system
pacstrap /mnt base-devel

#copy necessary files to new root and continue install process
cp -r build_scripts pacman_hooks polkit_rules systemd_units /mnt
arch-chroot /mnt mnt/build_scripts/arch-post-chroot.sh

######################### Clean up and reboot ####################
##################################################################

#remove build files
#unmount all and reboot