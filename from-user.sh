
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -sicL

install='yay -Sya --nocombinedupgrade --noconfirm --sudoloop android-studio-beta android-sdk android-docs'
install+=' rstudio-desktop-bin oh-my-zsh-git oh-my-zsh-powerline-theme-git spotify-dev drive-bin'
install+=' ruby-taskwarrior-web zotero-beta android-sdk-platform-tools discord-canary'

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
