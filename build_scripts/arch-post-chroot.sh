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
echo -e '127.0.1.1\tlabyrinth.localdomain\tlabyrinth' >> etc/hosts

# the following lines detect if it is a laptop, then writes a file disabling
# waking up if lid is opened.
# NOTE: may need to find better, more consistent, option

read -r chassis_type < /sys/class/dmi/id/chassis_type

if [[ ${chassis_type} -eq 9]] || [[ ${chassis_type} -eq 10]]; then
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
source pacman_hooks/hook_populator.sh
rm -r pacman_hooks

#update the mirrorlist
wget -O etc/pacman.d/mirrorlist https://www.archlinux.org/mirrorlist/?country=US&protocol=https&ip_version=4&ip_version=6&use_mirror_status=on
sed -i 's/^#Server/Server/' etc/pacman.d/mirrorlist

#install a few necessary packages for rest of build
pacman -Su --no-confirm grub os-prober firejail git chrony xorg-server sudo linux-hardened linux-hardened-headers

################ Setup Bootloader #################################
###################################################################

#TODO: wrap in if statement, have seperate setups for grub and rEFInd
grub-install --target=i386-pc /dev/sda

grub-mkconfig  -o boot/grub/grub.cfg

#enable apparmor in kernel at boot
sed -i '/GRUB_CMDLINE_LINUX/s/=""/="apparmor=1\ security=apparmor"' etc/default/grub

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
se="menuentry\ \'Arch Linux,\ with\ Linux\ linux-hardened\'"
sed -i "s/$se/$se\ --unrestricted\ /" boot/grub/grub.cfg

######################### Install GPU drivers #####################
###################################################################

update-pciids

vga_driver=$(lspci | grep 'vga\|3d\|2d')

if [[ ${vga_driver} == *"Intel"* ]]; then
    pacman -Syyu --noconfirm mesa lib32-mesa
elif [[ ${vga_driver} == *"Nvidia"* ]]; then
    pacman -Syyu --noconfirm nvidia-dkms lib32-nvidia-utils nvidia-settings
fi


###################### Setup User and begin Build #################
###################################################################

#ask for password
#read -sp "Please enter your user password: " PWD

#enable wheel
sed -i '/%wheel\ ALL=(ALL)\ ALL/s/^#//' etc/sudoers

#create user and add them to necessary groups
useradd -m -G wheel,games,proc -s bin/zsh $USERNAME

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

##################### NM Setup ##################################
#################################################################

echo -e '[main]\nwifi.cloned-mac-address=random' >> etc/NetworkManager/conf.d/mac_address_randomization.conf
echo -e '[main]\ndhcp=dhclient' >> etc/NetworkManager/conf.d/dhcp-client.conf
echo -e '[main]\ndns=dnsmasq' >> etc/NetworkManager/conf.d/dns.conf
echo -e '[main]\nrc-manager=resolvconf' >> etc/NetworkManager/conf.d/rc-manager.conf
echo -e 'conf-file=/usr/share/dnsmasq/trust-anchors.conf\ndnssec\n' >> etc/NetworkManager/dnsmasq.d/dnssec.conf
echo -e 'options="edns0 single-request-reopen"\nnameservers="::1 127.0.0.1"\ndnsmasq_conf=/etc/NetworkManager/dnsmasq.d/dnsmasq-openresolv.conf\ndnsmasq_resolv=/etc/NetworkManager/dnsmasq.d/dnsmasq-resolv.conf' >> etc/resolvconf.conf
sed -i '/require_dnssec/s/false/true/' etc/dnscrypt-proxy/dnscrypt-proxy.toml

##################### Systemd Setup ###############################
###################################################################

systemctl disable systemd-timesyncd.service
systemctl enable chronyd.service

systemctl enable apparmor.service

systemctl enable bluetooth.service
systemctl enable gdm.service

systemctl enable dnscrypt-proxy.service

#################### Harden System ##############################
#################################################################

#set up polkit rules for allowing certain functionality for user
polkit_rules/polkit_populator.sh
rm -r polkit rules

#change default permissions 
chmod 700 boot etc/{iptables,arptables} #NOTE: DESPERATELY NEED TO MAKE SIMPLE FIREWALLS
sed -i "/umask"'s/^0022/0077//' etc/profile

#hide processes from all users not part of proc group
echo -e 'proc\t/proc\tproc\tnosuid,nodev,noexec,hidepid=2,gid=proc\t0\t0' >> etc/fstab

gpasswd -a gdm proc

mkdir etc/systemd/system/systemd-logind.service.d
echo -e '[Service]\nSupplementaryGroups=proc' >> etc/systemd/system/systemd-logind.service.d/hidepid.conf

# change log group to wheel in order to allow notifications
sed -i "/log_group/s/root/wheel/" etc/audit/auditd.conf

#firejail apparmor integration, disallow net globally
mv mnt/firejail_profiles/globals.local etc/firejail/globals.local
apparmor_parser -r etc/apparmor.d/firejail-default



#set user password here
passwd $USERNAME
exit