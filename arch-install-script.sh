########################### Get User Input #######################
##################################################################
#loadkeys gb

echo -e "Please enter the desired Hostname"
read HOSTNAME
echo HostName is $HOSTNAME

echo -e "Please enter the desired Username"
read USERNAME
echo Username is $USERNAME

current_directory=$(pwd)

###########  Set pacman options  ##################################
###################################################################

echo -e 'setting pacman options\n\n'

echo -e 'enabling color and candy\n\n'

sed -i '/Color/s/^#//' /etc/pacman.conf
sed -i '/Color/a ILoveCandy' /etc/pacman.conf

echo -e 'enabling multilib repository\n\n'
sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf

echo -e 'setting package signing option to require signature\n\n'

sed -i '/\[core\]/a SigLevel\ =\ PackageRequired' /etc/pacman.conf
sed -i '/\[multilib\]/a SigLevel\ =\ PackageRequired' /etc/pacman.conf
sed -i '/\[community\]/a SigLevel\ =\ PackageRequired' /etc/pacman.conf
sed -i '/\[extra\]/a SigLevel\ =\ PackageRequired' /etc/pacman.conf

echo -e 'enable xynes repo'

echo -e "[xyne-x86_64]\n# A repo for Xyne's own projects: https://xyne.archlinux.ca/projects/\n" >>/etc/pacman.conf
echo -e '#Packages for the "x86_64" architecture.\n# Note that this includes all packages in [xyne-any].\nSigLevel = Required\nInclude = /etc/pacman.d/xyne-mirrorlist' >>/etc/pacman.conf

# running makepkg as nobody user
# mkdir /home/build
# chgrp nobody /home/build
# chmod g+ws /home/build
# setfacl -m u::rwx,g::rwx /home/build
# setfacl -d --set u::rwx,g::rwx,o::- /home/build

pacman -Sy powerpill

########################### Begin Install ########################
##################################################################

timedatectl set-ntp true

genfstab -U /mnt >>/mnt/etc/fstab

echo -e 'creating the base system\n\n'

source /arch-install-scripts/build_scripts/package_lists/system_base.sh
./powerstrap /mnt ${base[*]}

echo -e 'copytng pacman configuration\n'
cp /etc/pacman.conf /mnt/etc/pacman.conf

echo -e 'setting hostname\n'
echo "$HOSTNAME" >>/mnt/etc/hostname

echo -e 'setting local host\n'

echo -e '127.0.0.1\tlocalhost' >>/mnt/etc/hosts
echo -e '::1\tlocalhost' >>/mnt/etc/hosts
echo -e "127.0.1.1\t$HOSTNAME.localdomain\t$HOSTNAME" >>/mnt/etc/hosts

echo -e 'enabling en_US.UTF-8 for localgen\n'
sed -i '/#en_US.UTF-8\ UTF-8/s/^#//' /mnt/etc/locale.gen

#enable wheel
sed -i '/%wheel\ ALL=(ALL)\ ALL/s/^#//' /mnt/etc/sudoers

#echo 'KEYMAP=gb' >> /mnt/etc/vconsole.conf

########################## Configure Grub ########################
##################################################################

echo -e 'editing default grub\n'

#enable apparmor in kernel at boot
sed -i "/GRUB_CMDLINE_LINUX/s/=\"\"/=\"apparmor=1\ security=apparmor\"" /etc/default/grub

#Save last choice
sed -i '/GRUB_DEFAULT/s/0/saved/' /mnt/etc/default/grub
sed -i '/GRUB_SAVEDEFAULT/s/^#//' /mnt/etc/default/grub

#hide grub menu
mkdir /mnt/etc/grub.d
echo 'GRUB_FORCE_HIDDEN_MENU="true"' >>/mnt/etc/default/grub
mv tools/31-hold-shift /mnt/etc/grub.d/
chmod a+x /mnt/etc/grub.d/31-hold-shift

#allow unrestricted booting of hardened kernel
se="menuentry\ \'Arch Linux'"
sed -i "s/$se/$se\ --default\ --unrestricted\ /" /mnt/etc/default/grub

#password protect grub menu
# disabling until I get the base stuff working, also may move to another confirmation method
#echo 'enter your desired grub password: '
#read grub_pwd
#echo grub_pwd >> meow
#echo grub_pwd >> meow

#grub_output="$(cat meow | grub-mkpasswd-pbkdf2 | awk '/grub.pbkdf/{print$NF}')"
#echo -e "set superusers=\"$USERNAME\"\npassword_pbkdf2 username $grub_output" >> etc/grub.d/40_custom

# rm meow

######################### Populate pacman hooks #################
#################################################################

echo 'populating hooks'
hooks_location='/mnt/etc/pacman.d/hooks/'

mkdir -p $hooks_location

vga_driver=$(lspci | grep 'vga\|3d\|2d')

for file in $current_directory/pacman_hooks/*.hook; do
    if [[ $file != *"populator"* ]]; then
        base_file=$(echo $(basename "$file"))
        if [[ $base_file == *"nvidia"* ]]; then
            if [[ ${vga_driver} == *"Nvidia"* ]]; then
                echo -e "installing $base_file\n"
                cp -i "$current_directory/pacman_hooks/$base_file" "$hooks_location$base_file"
            else
                echo -e "skipping $base_file because there is no nvidia gpu\n"
            fi
        else
            echo -e "installing $base_file\n"
            cp -i "$current_directory/pacman_hooks/$base_file" "$hooks_location$base_file"
        fi
    fi
done

########################## setup Networking #######################
###################################################################

echo -e 'setting up network manager\n\n'
echo -e '[main]\nwifi.cloned-mac-address=random' >>/mnt/etc/NetworkManager/conf.d/mac_address_randomization.conf
echo -e '[main]\ndhcp=dhclient' >>/mnt/etc/NetworkManager/conf.d/dhcp-client.conf
echo -e '[main]\nrc-manager=resolvconf' >>/mnt/etc/NetworkManager/conf.d/rc-manager.conf

echo -e 'setting up openreslver\n\n'
#it seems that networkManager and unbound play better together when dns is set to None
#echo -e '[main]\ndns=unbound' >>/mnt/etc/NetworkManager/conf.d/dns.conf
echo -e 'name_servers="::1 127.0.0.1"' >>/mnt/etc/resolvconf.conf
echo -e 'unbound_conf=/etc/unbound/resolvconf.conf' >>/mnt/etc/resolvconf.conf
echo -e 'conf-file=/usr/share/dnsmasq/trust-anchors.conf\ndnssec\n' >>/mnt/etc/NetworkManager/dnsmasq.d/dnssec.conf
echo -e 'options="edns0 single-request-reopen"\n' >>/mnt/etc/resolvconf.conf

echo -e 'setting up local domain name resolution\n\n'
sed -i '/require_dnssec/s/false/true/' /mnt/etc/dnscrypt-proxy/dnscrypt-proxy.toml
echo -e "listen_addresses = ['127.0.0.1:53000', '[::1]:53000']\n" >>/mnt/dnscrypt-proxy.toml
echo -e 'manually edit dnssec-conf. '
#################### Harden System ##############################
#################################################################

#change default permissions
chmod 700 /mnt/boot /mnt/etc/{iptables,arptables} #NOTE: DESPERATELY NEED TO MAKE SIMPLE FIREWALLS
sed -i "/umask"'s/^0022/0077//' /mnt/etc/profile

echo -e 'hiding processes from all users not part of proc group\n\n'
echo -e 'proc\t/proc\tproc\tnosuid,nodev,noexec,hidepid=2,gid=proc\t0\t0' >>/mnt/etc/fstab

# gpasswd -a gdm proc

mkdir -p /mnt/etc/systemd/system/systemd-logind.service.d
echo -e '[Service]\nSupplementaryGroups=proc' >>/mnt/etc/systemd/system/systemd-logind.service.d/hidepid.conf

#change log group to wheel in order to allow notifications
sed -i "/log_group/s/root/wheel/" /mnt/etc/audit/auditd.conf

#firejail apparmor integration, disallow net globally
mkdir -p /mnt/etc/firejail
echo -e 'net none\napparmor' >>/mnt/etc/firejail/globals.local

##################### Change root ################################
##################################################################

#copy necessary files to new root and continue install process
cp tools/post-reboot.service /mnt/etc/systemd/system/post-reboot.service
chmod +x /mnt/post-reboot.sh

#begin install
arch-chroot /mnt mnt/build_scripts/arch-post-chroot.sh
wait $1

######################### Clean up and reboot ####################
##################################################################

umount -a
#unmount all and reboot
