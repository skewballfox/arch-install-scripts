################ Setup Host #######################################
###################################################################

ln -sf usr/share/zoneinfo/US/Central etc/localtime
hwclock --systohc

# definitely change this 
# nano etc/locale.gen
sed -i '/#en_US.UTF-8\ UTF-8/s/^#//' etc/locale.gen
locale-gen

#set language options and keyboard
echo 'LANG=en_US.UTF-8' >>  etc/locale.conf
loadkeys usr/share/kbd/keymaps/sun/sunt6-uk.map.gz
echo 'KEYMAP=gb' >> etc/vconsole.conf


read -p "Please enter a hostname: " HOSTNAME
echo "$HOSTNAME" >> etc/hostname

echo -e '127.0.0.1\t localhost' >> etc/hosts
echo -e '::1\t localhost' >> etc/hosts
echo -e '127.0.1.1\t labyrinth.localdomain\t labyrinth' >> etc/hosts

# the following lines detect if it is a laptop, then writes a file disabling
# waking up if lid is opened.
# NOTE: may need to find better, more consistent, option

read -r chassis_type < /sys/class/dmi/id/chassis_type

if [[$chassis_type -eq 9]] || [[$chassis_type -eq 10]]; then
  echo 'w /proc/acpi/wakeup - - - - LID' >> etc/tmpfiles.d/disable-lid-wakeup.conf
fi

#need to add something for fstab

###########  Set pacman options  ##################################
###################################################################

#enable color and candy
sed -i '/Color/s/^#//' etc/pacman.conf
sed -i '/Color/a ILoveCandy' etc/pacman.conf


#enable multilib repository
sed -i "/\[multilib\]/,/Include/"'s/^#//' etc/pacman.conf

#set package signing option to require signature. 
sed -i '/\[core\]/a SigLevel\ =\ PackageRequired' etc/pacman.conf
sed -i '/\[multilib\]/a SigLevel\ =\ PackageRequired' etc/pacman.conf
sed -i '/\[community\]/a SigLevel\ =\ PackageRequired' etc/pacman.conf
sed -i '/\[extra\]/a SigLevel\ =\ PackageRequired' etc/pacman.conf

#populate pacman keyring
pacman-key --init
pacman-key --populate archlinux

# install pacman hooks
source ./pacman_hooks/hook_populator.sh


#update the mirrorlist
wget -O etc/pacman.d/mirrorlist https://www.archlinux.org/mirrorlist/?country=US&protocol=https&ip_version=4&ip_version=6&use_mirror_status=on
sed -i 's/^#Server/Server/' etc/pacman.d/mirrorlist

#install a few necessary packages for rest of build
pacman -Su grub os-prober firejail git chrony xorg-server sudo

################ Setup Bootloader #################################
###################################################################

#TODO: wrap in if statement, have seperate setups for grub and rEFInd
grub-install --target=i386-pc /dev/sda

#enable apparmor in kernel at boot
sed -i '/GRUB_CMDLINE_LINUX/s/=""/="apparmor=1\ security=apparmor"' etc/default/grub

#Save last choice
sed -i '/GRUB_DEFAULT/s/0/saved/' etc/default/grub 
sed -i '/GRUB_SAVEDEFAULT/s/^#//' etc/default/grub


grub-mkconfig  -o boot/grub/grub.cfg

######################### Install GPU drivers #####################
###################################################################

update-pciids

vga_driver=$(lspci | grep 'vga\|3d\|2d')

if [[ $vga_driver == *"Intel"* ]]; then
    pacman -Syyu --noconfirm mesa lib32-mesa
elif [[ $vga_driver == *"Nvidia"* ]]; then
    pacman -Syyu --noconfirm nvidia-dkms lib32-nvidia-utils nvidia-settings
fi


###################### Setup User and begin Build #################
###################################################################

#ask for username
read -p "Please enter your username: " USERNAME
#ask for password
read -sp "Please enter your user password: " PWD

#enable wheel
sed -i '/%wheel\ ALL=(ALL)\ ALL/s/^#//' etc/sudoers

useradd -m -G wheel,games -s bin/zsh $USERNAME

#mv necessary files/folders and change permissions
mv -r package_lists home/$USERNAME/
mv from-user.sh home/$USERNAME/

chown -R $USERNAME: home/$USERNAME/package_lists
chown -R $USERNAME: home/$USERNAME/from-user.sh
chmod -R u+rx home/$USERNAME/package_lists
chomd -r u+rx home/$USERNAME/from-user.sh

#call the build script from user
su - $USERNAME -c home/$USERNAME/from-user.sh
wait $!

rm -r home/$USERNAME/package_lists
rm -r home/$USERNAME/from-user.sh

#disable root
passwd -l root

##################### Systemd Setup ###############################
###################################################################

systemctl disable systemd-timesyncd.service
systemctl enable chronyd.service

systemctl enable apparmor.service

systemctl enable bluetooth.service
systemctl enable gdm.service

#################### Harden System ##############################
#################################################################

chmod 700 boot etc/{iptables,arptables}
sed -i "/umask"'s/^0022/0077//' etc/profile


mv mnt/firejail_profiles/globals.local etc/firejail/globals.local
#firejail apparmor integration
apparmor_parser -r etc/apparmor.d/firejail-default

#set user password here
passwd $USERNAME
exit