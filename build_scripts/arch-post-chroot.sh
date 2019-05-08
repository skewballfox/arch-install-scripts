ln -sf /usr/share/zoneinfo/US/Central /etc/localtime
hwclock --systohc
nano etc/locale.gen
locale-gen
echo 'LANG=en_US.UTF-8' >>  /etc/locale.conf
loadkeys usr/share/kbd/keymaps/sun/sunt6-uk.map.gz
echo 'KEYMAP=gb' >> /etc/vconsole.conf
echo 'labyrinth' >> /etc/hostname

echo '127.0.0.1 localhost' >> etc/hosts
echo '::1      localhost' >> etc/hosts
echo '127.0.1.1 labyrinth.localdomain labyrinth' >> etc/hosts

pacman -Su --noconfirm grub os-prober
grub-install --target=i386-pc /dev/sda
grub-mkconfig  -o /boot/grub/grub.cfg

useradd -m -G wheel,games -s /bin/zsh daedalus
EDITOR=nano visudo
passwd -l root
pacman -Su --noconfirm firejail usbguard chrony xorg-server



systemctl disable systemd-timesyncd.service
systemctl enable chronyd.service

sed -i "/umask"'s/^022/0077//' /etc/profile

sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf

update-pciids

vga_driver=$(lspci | grep 'vga\|3d\|2d')

if [[ $vga == *"Intel"* ]]; then
    pacman -Syyu --noconfirm mesa lib32-mesa
elif [[ $vga == *"Nvidia"* ]]; then
    pacman -Syyu --noconfirm nvidia-dkms lib32-nvidia-utils
fi
done

pacman -Syyu --noconfirm mesa lib32-mesa

chmod 700 /boot /etc/{iptables,arptables}
