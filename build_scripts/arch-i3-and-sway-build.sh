#this is a build for i3 and sway, to allow for easy navigation between x and wayland
build='pacman -Syyu --noconfirm i3-wm sway xorg-xrdb'

#for session login, gdm is used for wayland xorg compatibility, gnome polkit is used for compatibility
build+='gdm polkit polkit-gnome'

#just fonts
build+=' ttf-font-awesome ttf-fira-code font-mathematica noto-fonts-cjk noto-fonts-emoji'

#common applications
build+=' firefox chromium mpv qbittorrent caprine okular phonon-qt5-gstreamer'

#for linux magic
build+='rxvt-unicode task zsh autocutsel ranger wget'

#for coding
build+=' atom code apm git cmake zeal'

#for hardware function keys and interfacing
build+=' xbacklight alsa-utils pulseaudio pulseaudio-alsa pulseaudio-bluetooth libpulse'

#python tools and libraries, and r
build+=' python-numpy python-matplotlib python-selenium python-requests python-beautifulsoup4'
build+=' python-sympy python-pip ipython jupyter-notebook opencv geckodriver r'

#for linting python and bash
build+=' bash-language-server python-pylint python-language-server python-pyflakes yapf'
build+=' python-mccabe python-pycodestyle python-pydocstyle python-rope'

#for making i3 closer to a full fledged desktop environment
build+=' xscreensaver compton dmenu redshift'

#for editing video and image formats
build+=' blender gimp'

#for working with mysql databases
build+=' mariadb mysqlworkbench'

#for working with java programs, openjdk11
build+=' jre-openjdk jdk-openjdk openjdk-doc'

#for working with virtual machines
build+=' virtualbox virtualbox-host-dkms linux-headers dkms virtualbox-guest-iso virtualbox-guest-utils '

#for working with pandoc and resume project
build+=' pandoc texlive-core'

#for interfacing with network and other devices
build+=' networkmanager network-manager-applet blueman'

#For browsing files and controlling USBs
build+=' thunar thunar-volman gvfs gparted'

#For desktop wallpaper, system notifications, and information display
build+=' feh dunst conky conky-manager'

#for screenshots and some locking
build+=' scrot imagemagick wmctrl'

#for improving password security for the programs I write
build+=' gnupg pass'

eval $build

#this makes java use system anti-aliased fonts and make swing use the GTK look and feel
echo "export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel'" >> /etc/profile.d/jre.sh

systemctl enable bluetooth.service
systemctl enable lightdm.service
