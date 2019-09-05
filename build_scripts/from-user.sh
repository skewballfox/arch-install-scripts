################ Setup git credentials #################
########################################################

git config --global user.email "joshua.ferguson.273@gmail.com"
git config --global user.name "Joshua Ferguson"

############### Setup Dotfiles #########################
########################################################

echo ".cfg">> .gitignore
alias config='git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
git clone --bare https://github.com/skewballfox/.cfg.git $HOME/.cfg 

config checkout -f

config config --local status.showUntrackedFiles no

echo -e 'pinentry-program /usr/bin/pinentry-gnome3' >> $HOME/.gnupg/gpg-agent.conf

############## Source package installers ###############
########################################################

#yay: my current aur helper, may move to baurerpill

git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -sicL
cd ~
rm -r yay

#easier than installing dependencies from source
yay -S powerpill

#uncomment command write server list to file 
#add server list to etc/powerpill/powerpill.json rsync server section
reflector -p rsync -f 7 -l 7 >> temp 
sed -e '/Server\ =/!d' temp
sed -e 's/Server\ =\ //' temp
sed -e 's/.*/"&"/' temp
sed -e '$!s/$/,/' temp
sed -e ':a;N;$!ba;s/\n//g' temp

#rslist="$(cat temp)"
#could never get the following line working
#sudo cat /etc/powerpill/powerpill.json | jq -s " .rsync.servers = [$rslist]" /etc/powerpill/powerpill.json


################### Install and setup Packages ###########
##########################################################

source package_lists/*

sudo powerpill -Syyu --noconfirm ${build_main[*]}

yay -Sya --pacman powerpill --noconfirm --nocombinedupgrade --sudoloop ${build_aur[*]}

yay -Sya --pacman powerpill --sudoloop

# install a couple of user python packages
source package_lists/user_python_packages.sh
pip install --user --upgrade ${user_pip[*]}

#make directory so zathura can save bookmarks
mkdir .local/share/zathura

#set default directories and filetypes
xdg-mime default zathura.desktop application/pdf
xdg-mime default feh.desktop image/jpeg
xdg-settings set default-web-browser firefox-developer-edition.desktop

mkdir gdrive

mkdir Media
mkdir Media/Photos
mkdir Media/Videos
mkdir Media/Music

mkdir Workspace
mkdir Workspace/Templates

xdg-user-dirs-update --set DOCUMENTS $HOME/Gdrive
xdg-user-dirs-update --set PICTURES $HOME/Media/Photos
xdg-user-dirs-update --set VIDEOS $HOME/Media/Videos
xdg-user-dirs-update --set MUSIC $HOME/Media/Music
xdg-user-dirs-update --set TEMPLATES $HOME/Workspace/Templates

mkdir $HOME/Media/Photos/Screenshots

#this makes java use system anti-aliased fonts and make swing use the GTK look and feel
sudo echo "export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel'" >> etc/profile.d/jre.sh

############### Setup Dotfiles #########################
########################################################

echo ".cfg">> .gitignore
alias config='git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
git clone --bare https://github.com/skewballfox/.cfg.git $HOME/.cfg 

config checkout -f

config config --local status.showUntrackedFiles no

echo -e 'pinentry-program /usr/bin/pinentry-gnome3' >> $HOME/.gnupg/gpg-agent.conf

#################### Setup Workspace ################################
#####################################################################

cd Workspace

mkdir System_Tools
mkdir Open_Source_Projects

cd System_Tools

source /package_lists/git_system_tools.sh

cd writing_tools
./populate_systemd

cd ..

cd ../Open_Source_Projects

# look up open source projects. 

############### Add groups for android development ##############
#################################################################

sudo groupadd sdkusers
sudo gpasswd -a daedalus sdkusers
sudo chown -R :sdkusers /opt/android-sdk/
sudo chmod -R g+w /opt/android-sdk/
newgrp sdkusers


################ exit and return control ########################
#################################################################
exit