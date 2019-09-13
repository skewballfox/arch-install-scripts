################ Setup Host #######################################
###################################################################

ln -sf /usr/share/zoneinfo/US/Central /etc/localtime
hwclock --systohc

# definitely change this 
# nano etc/locale.gen
sed -i '/#en_US.UTF-8\ UTF-8/s/^#//' etc/locale.gen
locale-gen

#set language options and keyboard
echo 'LANG=en_US.UTF-8' >>  etc/locale.conf
loadkeys usr/share/kbd/keymaps/sun/sunt6-uk.map.gz
echo 'KEYMAP=gb' >> etc/vconsole.conf

#get user input

#ask for hostname
echo -n 'Please enter a hostname: '
read HOSTNAME
echo "$HOSTNAME" >> etc/hostname

#ask for username
echo 'Please enter your username: '
read USERNAME

echo -e '127.0.0.1\tlocalhost' >> etc/hosts
echo -e '::1\tlocalhost' >> etc/hosts
echo -e "127.0.1.1\t$HOSTNAME.localdomain\t$HOSTNAME" >> etc/hosts

# the following lines detect if it is a laptop, then writes a file disabling
# waking up if lid is opened.
# NOTE: may need to find better, more consistent, option
# NOTE: may use this to determine rest of the build process

read -r chassis_type < /sys/class/dmi/id/chassis_type

if [[ ${chassis_type} == 9 ]] || [[ ${chassis_type} == 10 ]]; then
  echo 'w /proc/acpi/wakeup - - - - LID' >> etc/tmpfiles.d/disable-lid-wakeup.conf
fi

###########  Set pacman options  ##################################
###################################################################

#populate pacman keyring
pacman-key --init
pacman-key --populate archlinux

#update the mirrorlist
reflector --verbose --country 'US' -l 20 -p https --sort rate --save /etc/pacman.d/mirrorlist
pacman -Syu 

################ Setup Bootloader #################################
###################################################################

#TODO: wrap in if statement, have seperate setups for grub and rEFInd
grub-install --target=i386-pc /dev/sda

grub-mkconfig  -o boot/grub/grub.cfg

#enable apparmor in kernel at boot
sed -i "/GRUB_CMDLINE_LINUX/s/=\"\"/=\"apparmor=1\ security=apparmor\"" etc/default/grub

#Save last choice
sed -i '/GRUB_DEFAULT/s/0/saved/' etc/default/grub 
sed -i '/GRUB_SAVEDEFAULT/s/^#//' etc/default/grub

mkdir etc/grub.d

#password protect grub menu
echo 'enter your desired grub password: '
read grub_pwd
echo grub_pwd >> meow
echo grub_pwd >> meow

grub_output="$(cat meow | grub-mkpasswd-pbkdf2 | awk '/grub.pbkdf/{print$NF}')"
echo -e "set superusers=\"$USERNAME\"\npassword_pbkdf2 username $grub_output" >> etc/grub.d/40_custom

rm meow

#hide grub menu
echo 'GRUB_FORCE_HIDDEN_MENU="true"' >> etc/default/grub
mv build_scripts/31-hold-shift etc/grub.d/
chmod a+x /etc/grub.d/31-hold-shift
grub-mkconfig  -o boot/grub/grub.cfg

#allow unrestricted booting of hardened kernel
se="menuentry\ \'Arch Linux'"
sed -i "s/$se/$se\ --default\ --unrestricted\ /" boot/grub/grub.cfg



###################### Setup User and begin Build #################
###################################################################

#so my zsh pacman hook will work
mkdir var/cache/zsh

#enable wheel
sed -i '/%wheel\ ALL=(ALL)\ ALL/s/^#//' etc/sudoers

#create user and add them to necessary groups
useradd -m -G wheel,games,proc -s bin/zsh $USERNAME

#mv necessary files/folders and change permissions
mv -r package_lists home/$USERNAME/
mv from-user.sh home/$USERNAME/
mv post-login.sh home/$USERNAME/
mv vm-setup.sh home/$USERNAME/

chown -R $USERNAME: home/$USERNAME/package_lists
chown -R $USERNAME: home/$USERNAME/from-user.sh
chown -R $USERNAME: home/$USERNAME/post-login.sh
chown -R $USERNAME: home/$USERNAME/vm-setup.sh

chmod -R u+rx home/$USERNAME/package_lists
chmod -r u+rx home/$USERNAME/from-user.sh
chmod -r u+rx home/$USERNAME/post-login.sh
chmod -r u+rx home/$USERNAME/vm-setup.sh

#call the build script from user
su - $USERNAME -c home/$USERNAME/from-user.sh
wait $!

rm -r home/$USERNAME/package_lists
rm -r home/$USERNAME/from-user.sh

#disable root
passwd -l root

#set user password
passwd $USERNAME

##################### Systemd Setup ###############################
###################################################################

mv systemd_services/post-reboot.service etc/systemd/system/post-reboot.service
#sed -i "s/myuser/$USER/" /etc/systemd/system/pidgin-suspend.service  

rm -r systemd_services
chmod +x build_scripts/post-reboot.sh

systemctl daemon-reload
systemctl enable post-reboot.service

systemctl disable systemd-timesyncd.service
systemctl enable chronyd.service

systemctl enable apparmor.service



exit