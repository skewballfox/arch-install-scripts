base=( autoconf automake binutils bison fakeroot file findutils flex )
base+=( gawk gcc gettext grep groff gzip libtool m4 make pacman patch)
base+=( pkgconf sudo systemd texinfo bash bzip2 coreutils cryptsetup )
base+=( device-mapper dhcpcd diffutils e2fsprogs file filesystem gawk)
base+=( gcc-libs gettext glibc grep gzip inetutils iproute2 iputils jfsutils)
base+=( less licenses linux-firmware logrotate lvm2 man-db man-pages mdadm)
base+=( netctl pciutils perl procps-ng psmisc reiserfsprogs s-nail sed shadow)
base+=( sysfsutils systemd-sysvcompat tar texinfo usbutils util-linux which)
base+=( xfsprogs linux-hardened linux-hardened-headers kak git grub os-prober)
base+=( reflector )

######################### Install GPU drivers #####################
###################################################################

update-pciids

vga_driver=$(lspci | grep 'vga\|3d\|2d')

if [[ ${vga_driver} == *"Intel"* ]]; then
    base+=( mesa lib32-mesa )
elif [[ ${vga_driver} == *"Nvidia"* ]]; then
    base+=( nvidia-dkms lib32-nvidia-utils nvidia-settings )
fi