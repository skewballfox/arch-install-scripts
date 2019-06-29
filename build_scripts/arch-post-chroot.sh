
ln -sf usr/share/zoneinfo/US/Central etc/localtime
hwclock --systohc

# definitely change this 
nano etc/locale.gen
locale-gen

#set language options and keyboard
echo 'LANG=en_US.UTF-8' >>  etc/locale.conf
loadkeys usr/share/kbd/keymaps/sun/sunt6-uk.map.gz
echo 'KEYMAP=gb' >> etc/vconsole.conf

#ask for hostname and set to variable
echo 'labyrinth' >> etc/hostname

echo '127.0.0.1 localhost' >> etc/hosts
echo '::1      localhost' >> etc/hosts
echo '127.0.1.1 labyrinth.localdomain labyrinth' >> etc/hosts

#populate pacman keyring
pacman-key --init
pacman-key --populate archlinux

#set pacman options
#enable color and candy
sed -i '/Color/s/^#//' etc/pacman.conf
sed -i '/Color/a ILoveCandy' >> etc/pacman.conf

#enable multilib repository
sed -i "/\[multilib\]/,/Include/"'s/^#//' etc/pacman.conf

#wrap in if statement, have seperate setups for grub and rEFInd
pacman -Su --noconfirm grub os-prober
grub-install --target=i386-pc /dev/sda
grub-mkconfig  -o boot/grub/grub.cfg

#ask for username
#ask for password

useradd -m -G wheel,games -s bin/zsh daedalus

#enable wheel
EDITOR=nano visudo
#disable root
passwd -l root

#install powerpill, could be used to really speed shit up, but I need to test it first
#su - daedalus -c "git clone https://aur.archlinux.org/powerpill.git && cd powerpill && makepkg -sicL && cd .. && rmdir powerpill"


pacman -Su --noconfirm firejail usbguard chrony xorg-server



systemctl disable systemd-timesyncd.service
systemctl enable chronyd.service

update-pciids

vga_driver=$(lspci | grep 'vga\|3d\|2d')

if [[ $vga == *"Intel"* ]]; then
    pacman -Syyu --noconfirm mesa lib32-mesa
elif [[ $vga == *"Nvidia"* ]]; then
    pacman -Syyu --noconfirm nvidia-dkms lib32-nvidia-utils nvidia-settings
fi

#control is passed to the i3wm build script
source ./arch-i3-and-sway-build.sh
wait $!

#TODO: pass control to from-user.sh

# the following lines detect if it is a laptop, then writes a file disabling
# waking up if lid is opened.
# NOTE: may need to find better, more consistent, option

read -r chassis_type < /sys/class/dmi/id/chassis_type

if [[$chassis_type -eq 9]] || [[$chassis_type -eq 10]]; then
  echo 'w /proc/acpi/wakeup - - - - LID' >> etc/tmpfiles.d/disable-lid-wakeup.conf
fi


#security modifications go here
chmod 700 boot etc/{iptables,arptables}
sed -i "/umask"'s/^0022/0077//' etc/profile

#set user password here
