build=(i3-wm sway xorg-xrdb)

#for session login, gdm is used for wayland xorg compatibility, gnome polkit is used for compatibility
#right now just setting it up, but I may want to change the startup conf
#on an nvidia system in order to run xorg rootless

if [[ $vga == *"Intel"* ]]; then
    build+=(gdm polkit polkit-gnome)
    # wayland setup
    build+=(mako slurp grim bemenu)
elif [[ $vga == *"Nvidia"* ]]; then
    build+=(gdm polkit polkit-gnome)
fi

# kernel stuff
build+=(linux-hardened linux-zen linux-zen-headers linux-hardened-headers crda usbctl)

#just fonts
build+=(ttf-font-awesome ttf-fira-code font-mathematica noto-fonts-cjk noto-fonts-emoji texlive-most)
build+=(awesome-terminal-fonts)

#common applications
build+=(firefox-developers-edition chromium mpv qbittorrent caprine zathura zathura-pdf-mupdf mupdf-tools zathura-djvu)
build+=(zathura-ps zathura-cb playonlinux wine winetricks wine_gecko wine-mono libreoffice-fresh)
build+=(anki)

#for linux magic
build+=(tmux termite rxvt-unicode task zsh autocutsel wget unrar dialog arch-wiki-lite w3m)
build+=(youtube-dl)

#for coding
build+=(code git cmake zeal kakoune meson ninja)

#for sqlite 
build+=(sqlite sqlite-analyzer sqlitebrowser)

#for hardware function keys and interfacing
build+=(xbacklight alsa-utils pulseaudio pulseaudio-alsa pulseaudio-bluetooth libpulse)

#python tools and libraries, and r
build+=(python-numpy python-matplotlib python-selenium python-requests python-beautifulsoup4)
build+=(python-sympy python-pip ipython jupyter-notebook opencv geckodriver r)
build+=(buildbot python-buildbot-www python-buildbot-console-view python-xdg)

#for linting python and bash
build+=(bash-language-server python-pylint python-language-server python-pyflakes yapf)
build+=(python-mccabe python-pycodestyle python-pydocstyle python-rope)


#for making i3 closer to a full fledged desktop environment
build+=(xscreensaver compton dmenu redshift)

#for recording and editing editing video and image formats
build+=(cheese blender gimp)

#for spellchecking
build+=(hunspell hunspell-en_US)

#for working with mysql databases
build+=(mariadb mysqlworkbench)

#for working with java programs, openjdk11
build+=(jre-openjdk jdk-openjdk openjdk-doc)

#for working with virtual machines
build+=(virtualbox virtualbox-host-dkms linux-headers dkms virtualbox-guest-iso virtualbox-guest-utils)
build+=(virtualbox-guest-dkms)

#for working with pandoc and resume project
build+=(pandoc texlive-core)

#for interfacing with network and other devices
build+=(networkmanager network-manager-applet blueman)

#For browsing files and controlling USBs
build+=(thunar ranger udiskie thunar-volman gvfs gparted ntfs-3g)

#For desktop wallpaper, system notifications, and information display
build+=(feh dunst conky conky-manager)

#for screenshots and some locking
build+=(scrot imagemagick wmctrl)

#for improving password security
build+=(gnupg pass browserpass-firefox browserpass-chromium)

# for my zsh setup
build+=(pkgfile zsh-completions zsh-syntax-highlighting zsh-theme-powerlevel9k)