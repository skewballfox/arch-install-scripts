##################### NM Setup ##################################
#################################################################
resolvconf -u

apparmor_parser -r /etc/apparmor.d/firejail-default

##################### Systemd Setup ###############################
###################################################################
systemctl daemon-reload

systemctl enable bluetooth.service

systemctl enable dnscrypt-proxy.service

systemctl disable post-reboot.service


#################### ALMOST DONE! ################################
##################################################################
#reboot
