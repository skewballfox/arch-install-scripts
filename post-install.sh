useradd -m -G wheel,games -s /bin/zsh daedalus
EDITOR=nano visudo
passwd -l root
pacman -Su --noconfirm firejail
sudo pacman -Su --noconfirm usbguard
sudo pacman -Su --noconfirm chrony
systemctl disable systemd-timesyncd.service
sudo pacman -Su --noconfirm xorg-server
nano /etc/pacman.conf
pacman -Su --noconfirm mesa lib32-mesa
