###################### Setup User and begin Build #################
###################################################################

#create user and add them to necessary groups
useradd -m -G wheel,games,proc -s bin/fish $USERNAME

echo -e "please enter a password for $USERNAME"

#set user password
passwd $USERNAME

#disable root
passwd -l root

######################## Miscellanious #######################
##############################################################

if [[ "$(command -v zsh)" ]]; then
    #so my zsh pacman hook will work
    mkdir /var/cache/zsh
fi

##################### NM Setup ##################################
#################################################################

resolvconf -u

apparmor_parser -r /etc/apparmor.d/firejail-default

##################### Systemd Setup ###############################
###################################################################
systemctl daemon-reload

#systemctl enable bluetooth.service

systemctl enable unbound.service

systemctl enable dnscrypt-proxy.service
systemctl disable systemd-timesyncd.service
systemctl enable chronyd.service

systemctl enable apparmor.service

#################### ALMOST DONE! ################################
##################################################################

delete $0
#reboot
