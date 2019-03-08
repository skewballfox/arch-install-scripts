git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -sicL
yay -Sya --nocombinedupgrade --noconfirm --sudoloop android-studio-beta android-sdk android-docs
rstudio-desktop-bin oh-my-zsh-git oh-my-zsh-powerline-theme-git spotify-dev drive-bin

sudo groupadd sdkusers
sudo gpasswd -a daedalus sdkusers
sudo chown -R :sdkusers /opt/android-sdk/
sudo chmod -R g+w /opt/android-sdk/
newgrp sdkusers

cd ~

mkdir Library
drive init gdrive
cd gdrive
drive pull --quiet Classes
drive pull --quiet bookmarks.db
