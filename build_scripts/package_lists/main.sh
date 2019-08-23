build_main=(i3-wm xorg-server xorg-xrdb chrony )

#for session login, gdm is used for wayland xorg compatibility, gnome polkit is used for compatibility
#right now just setting it up, but I may want to change the startup conf
#on an nvidia system in order to run xorg rootless

if [[ $vga == *"Intel"* ]]; then
    build_main+=(gdm polkit polkit-gnome)
    # wayland setup
    build_main+=(sway mako slurp grim bemenu)
elif [[ $vga == *"Nvidia"* ]]; then
    build_main+=(gdm polkit polkit-gnome)
fi

# kernel stuff
build_main+=(crda usbctl asp apparmor)

#just fonts
build_main+=(ttf-font-awesome ttf-fira-code font-mathematica noto-fonts-cjk noto-fonts-emoji texlive-most)
build_main+=(awesome-terminal-fonts)

#common applications
build_main+=(firefox-developers-edition chromium mpv qbittorrent caprine zathura zathura-pdf-mupdf mupdf-tools zathura-djvu)
build_main+=(zathura-ps zathura-cb playonlinux wine winetricks wine_gecko wine-mono libreoffice-fresh)
build_main+=(anki)

#for linux magic
build_main+=(tmux termite rxvt-unicode task zsh autocutsel wget unrar dialog arch-wiki-lite w3m)
build_main+=(youtube-dl)

#for coding
build_main+=(code git cmake zeal kakoune meson ninja)

#for sqlite 
build_main+=(sqlite sqlite-analyzer sqlitebrowser)

#for hardware function keys and interfacing
build_main+=(xbacklight alsa-utils pulseaudio pulseaudio-alsa pulseaudio-bluetooth libpulse)

#python tools and libraries, and r
build_main+=(python-numpy python-matplotlib python-selenium python-requests python-beautifulsoup4)
build_main+=(python-sympy python-pip ipython jupyter-notebook opencv geckodriver r)
build_main+=(buildbot python-buildbot-www python-buildbot-console-view python-xdg)

#for linting python and bash
build_main+=(bash-language-server python-pylint python-language-server python-pyflakes yapf)
build_main+=(python-mccabe python-pycodestyle python-pydocstyle python-rope)


#for making i3 closer to a full fledged desktop environment
build_main+=(xscreensaver compton dmenu redshift anyevent-i3 perl-json-xs)

#for recording and editing editing video and image formats
build_main+=(cheese blender gimp)

#for spellchecking
build_main+=(hunspell hunspell-en_US)

#for working with mysql databases
build_main+=(mariadb mysqlworkbench)

#for working with java programs, openjdk11
build_main+=(jre-openjdk jdk-openjdk openjdk-doc)

#for working with virtual machines
build_main+=(virtualbox virtualbox-host-dkms linux-headers dkms virtualbox-guest-iso virtualbox-guest-utils)
build_main+=(virtualbox-guest-dkms)

#for working with pandoc and resume project
build_main+=(pandoc texlive-core)

#for interfacing with network and other devices
build_main+=(networkmanager dhclient dnsmasq openresolv network-manager-applet blueman usbguard dnscrypt-proxy)
build_main+=(ldns)

#For browsing files and controlling USBs
build_main+=(thunar ranger udiskie thunar-volman gvfs gparted ntfs-3g)

#For desktop wallpaper, system notifications, and information display
build_main+=(feh dunst conky conky-manager)

#for screenshots and some locking
build_main+=(scrot imagemagick wmctrl xautolock)

#for improving password security
build_main+=(gnupg pass browserpass-firefox browserpass-chromium gnome-keyring libsecret seahorse)

# for my zsh setup
build_main+=(pkgfile zsh-completions zsh-syntax-highlighting zsh-theme-powerlevel9k)

#random security utilities
build_main+=(signify paxtest libsecret firejail)