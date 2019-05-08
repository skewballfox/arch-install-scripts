
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -sicL

sudo firecfg

install='yay -Sya --nocombinedupgrade --noconfirm --sudoloop'
# for working with android projects via android studio
install+=' android-studio-beta android-sdk android-docs android-sdk-platform-tools'
# a few installs for making this build unixporn worthy
install+=' i3lock-fancy-git oh-my-zsh-git oh-my-zsh-powerline-theme-git'
# for accessing useful social accounts
install+=' spotify-dev discord-canary'
# for interfacing with cloud services and personal libraries
install+=' drive-bin buku bukubrow ruby-taskwarrior-web'
# for using git with pass
install+=' pass-git-helper-git'
# why isn't this in available via the official repositories?
install+=' rstudio-desktop-bin'
# to customize gdm
install+=' gdm3setup-utils'

eval $install

cd ~
rm -r yay

sudo groupadd sdkusers
sudo gpasswd -a daedalus sdkusers
sudo chown -R :sdkusers /opt/android-sdk/
sudo chmod -R g+w /opt/android-sdk/
newgrp sdkusers

drive init gdrive
cd gdrive
drive pull --quiet Classes
drive pull --quiet .buku_db
drive pull --quiet Library
drive pull --quiet Docs
drive pull --quiet .task

cd ~

#to use pass in order to reduce the need for supplying credentials
git config --global credential.helper /usr/bin/pass-git-helper


mkdir .local/share/buku
ln -s ~/gdrive/.buku_db/bookmarks.db ~/.local/share/buku/bookmarks.db

echo ".cfg">> .gitignore
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
git clone --bare https://github.com/skewballfox/.cfg.git $HOME/.cfg


config checkout -f

config config --local status.showUntrackedFiles no

mkdir github
cd github

git clone https://github.com/skewballfox/number_theory_playground.git
git clone https://github.com/skewballfox/compilers_assignments.git
git clone https://github.com/skewballfox/Data_analysis_stuff.git
git clone https://github.com/skewballfox/daily_practice.git
git clone https://github.com/skewballfox/Computer_Organization_Stuff.git
git clone https://github.com/skewballfox/SauronsEye.git
git clone https://github.com/skewballfox/pomodoro_lock.git
git clone https://github.com/skewballfox/USM_Calendar_Scraper.git
