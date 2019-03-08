ln -sf /usr/share/zoneinfo/US/Central /etc/localtime
hwclock --systohc
nano etc/locale.gen 
locale-gen 
echo 'LANG=en_US.UTF-8' >>  /etc/locale.conf
loadkeys usr/share/kbd/keymaps/sun/sunt6-uk.map.gz
echo 'KEYMAP=sunt6-uk.map.gz' >> /etc/vconsole.conf
echo 'labyrinth' >> /etc/hostname
echo '127.0.0.1 localhost' >> etc/hosts
echo '::1      localhost' >> etc/hosts
echo '127.0.1.1 labyrinth.localdomain labyrinth' >> etc/hosts
passwd
pacman -Su --noconfirm grub os-prober
grub-install --target=i386-pc /dev/sda
grub-mkconfig  -o /boot/grub/grub.cfg
