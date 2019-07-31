git config --global user.email "joshua.ferguson.273@gmail.com"
git config --global user.name "Joshua Ferguson"
 
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -sicL
cd ~
rm -r yay
#uncomment command write server list to file 
#add server list to etc/powerpill/powerpill.json rsync server section

#reflector -p rsync -f 7 -l 7

#make directory so zathura can save bookmarks
mkdir .local/share/zathura
#set default directories


install='yay -Sya --nocombinedupgrade --noconfirm --sudoloop'
# for working with android projects via android studio
install+=' android-studio-beta android-sdk android-docs android-sdk-platform-tools'
# a few installs for making this build unixporn worthy
install+=' i3lock-fancy-git oh-my-zsh-git oh-my-zsh-powerline-theme-git otf-nerd-fonts-fira-code'
# for interfacing with cloud services and personal libraries
install+=' drive-bin buku bukubrow'
# for using git with pass
install+=' pass-git-helper-git'
# why isn't this in available via the official repositories?
install+=' rstudio-desktop-bin'
# to check java style with kak
install+=' checkstyle'
# firefox hardening
install+=' firefox-hardening hardened-malloc-git'

eval $install



# set up github to use pass
git config --global credential.helper /usr/bin/pass-git-helper


drive init gdrive
cd gdrive
drive pull --quiet Classes
drive pull --quiet .buku_db
drive pull --quiet Library
drive pull --quiet Docs
drive pull --quiet .task

cd ~



mkdir .local/share/buku
ln -s ~/gdrive/.buku_db/bookmarks.db ~/.local/share/buku/bookmarks.db

echo ".cfg">> .gitignore
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
git clone --bare https://github.com/skewballfox/.cfg.git $HOME/.cfg

#add git directory for firefox, set to setup firefox here

config checkout -f

config config --local status.showUntrackedFiles no

mkdir workspace
cd workspace

mkdir System_Tools
mkdir Open_Source_Projects

cd System_Tools
git clone https://github.com/skewballfox/arch-install-scripts.git
git clone https://github.com/skewballfox/writing_tools.git
git clone https://github.com/skewballfox/Ankimation.git
git clone https://github.com/skewballfox/pandoras_box.git
git clone https://github.com/skewballfox/SauronsEye.git
git clone https://github.com/skewballfox/USM_Calendar_Scraper.git

cd writing_tools
./populate_systemd
cd ..

cd ../Open_Source_Projects

# look up open source projects. 

sudo groupadd sdkusers
sudo gpasswd -a daedalus sdkusers
sudo chown -R :sdkusers /opt/android-sdk/
sudo chmod -R g+w /opt/android-sdk/
newgrp sdkusers

sudo firecfg