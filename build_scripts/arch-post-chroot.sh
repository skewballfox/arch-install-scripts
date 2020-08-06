################ Setup Host #######################################
###################################################################

echo -e 'setting up timezone'
ln -sf /usr/share/zoneinfo/US/Central /etc/localtime
hwclock --systohc

# definitely change this
# nano etc/locale.gen

locale-gen

#set language options and keyboard
echo 'LANG=en_US.UTF-8' >>etc/locale.conf

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

grub-mkconfig -o boot/grub/grub.cfg

exit
