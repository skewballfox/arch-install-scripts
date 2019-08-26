##################### NM Setup ##################################
#################################################################

echo -e '[main]\nwifi.cloned-mac-address=random' >> /etc/NetworkManager/conf.d/mac_address_randomization.conf
echo -e '[main]\ndhcp=dhclient' >> /etc/NetworkManager/conf.d/dhcp-client.conf
echo -e '[main]\ndns=dnsmasq' >> /etc/NetworkManager/conf.d/dns.conf
echo -e '[main]\nrc-manager=resolvconf' >> /etc/NetworkManager/conf.d/rc-manager.conf
echo -e 'conf-file=/usr/share/dnsmasq/trust-anchors.conf\ndnssec\n' >> /etc/NetworkManager/dnsmasq.d/dnssec.conf
echo -e 'options="edns0 single-request-reopen"\nnameservers="::1 127.0.0.1"\ndnsmasq_conf=/etc/NetworkManager/dnsmasq.d/dnsmasq-openresolv.conf\ndnsmasq_resolv=/etc/NetworkManager/dnsmasq.d/dnsmasq-resolv.conf' >> /etc/resolvconf.conf
sed -i '/require_dnssec/s/false/true/' /etc/dnscrypt-proxy/dnscrypt-proxy.toml

resolvconf -u

#################### Harden System ##############################
#################################################################

#set up polkit rules for allowing certain functionality for user
source /polkit_rules/polkit_populator.sh
rm -r /polkit rules

#change default permissions 
chmod 700 boot /etc/{iptables,arptables} #NOTE: DESPERATELY NEED TO MAKE SIMPLE FIREWALLS
sed -i "/umask"'s/^0022/0077//' /etc/profile

#hide processes from all users not part of proc group
echo -e 'proc\t/proc\tproc\tnosuid,nodev,noexec,hidepid=2,gid=proc\t0\t0' >> /etc/fstab

gpasswd -a gdm proc

mkdir /etc/systemd/system/systemd-logind.service.d
echo -e '[Service]\nSupplementaryGroups=proc' >> /etc/systemd/system/systemd-logind.service.d/hidepid.conf

# change log group to wheel in order to allow notifications
sed -i "/log_group/s/root/wheel/" /etc/audit/auditd.conf

#firejail apparmor integration, disallow net globally
mv mnt/firejail_profiles/globals.local /etc/firejail/globals.local
rm -r firejail_profiles

apparmor_parser -r /etc/apparmor.d/firejail-default

##################### Systemd Setup ###############################
###################################################################
systemctl daemon-reload

systemctl enable bluetooth.service
systemctl enable gdm.service

systemctl enable dnscrypt-proxy.service

systemctl disable post-reboot.service


#################### ALMOST DONE! ################################
##################################################################
reboot
