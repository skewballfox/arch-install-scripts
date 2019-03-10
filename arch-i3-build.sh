build='pacman -Syyu --noconfirm i3-wm compton firefox chromium atom code python-numpy python-matplotlib python-selenium ttf-fira-code opencv r rxvt-unicode'
build+=' font-mathematica zsh python-sympy mpv feh dunst ipython jupyter-notebook  networkmanager qbittorrent caprine ranger thunar git cmake zeal blueman'
build+=' lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings network-manager-applet xscreensaver xorg-xrdb dmenu ttf-font-awesome task autocutsel'
build+=' redshift apm bash-language-server scrot xbacklight alsa-utils imagemagick pulseaudio pulseaudio-alsa pulseaudio-bluetooth'
build+=' phonon-qt5-gstreamer okular'
eval $build

systemctl enable lightdm.service
