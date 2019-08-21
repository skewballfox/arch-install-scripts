################ Setup git credentials #################
########################################################

sudo pacman -S git

git config --global user.email "joshua.ferguson.273@gmail.com"
git config --global user.name "Joshua Ferguson"

############### Setup Dotfiles #########################
########################################################

echo ".cfg">> .gitignore
alias config='git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
git clone --bare https://github.com/skewballfox/.cfg.git $HOME/.cfg 

config checkout -f

config config --local status.showUntrackedFiles no

############## Source package installers ###############
########################################################

#yay: my current aur helper, may move to baurerpill

git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -sicL
cd ~
rm -r yay

#powerpill: what I want to move this script to in the future, for improved install speed

git clone https://aur.archlinux.org/powerpill.git
cd powerpill
makepkg -sicL
cd ~
rm -r powerpill

#test and add buarpill


#uncomment command write server list to file 
#add server list to etc/powerpill/powerpill.json rsync server section
reflector -p rsync -f 7 -l 7 >> temp 
sed -i '/Server\ =/!d' temp
sed -i 's/Server\ =\ //' temp
sed -i 's/.*/"&"/' temp
sed -i '$!s/$/,/' temp
rslist=(cat temp)

#could never get the following line working
#sudo sed -i '/"servers":/s/\[.*\]/[$rslist]/' etc/powerpill/powerpill.json


################### Install and setup Packages ###########
##########################################################

source package_lists/*

sudo pacaur -Syyu --noconfirm ${build_main[*]}
yay -Sya --noconfirm --nocombinedupgrade --sudoloop ${build_aur[*]}

# set up github to use pass
git config --global credential.helper /usr/bin/pass-git-helper

#make directory so zathura can save bookmarks
mkdir .local/share/zathura

#set default directories and filetypes
xdg-mime default zathura.desktop application/pdf

mkdir gdrive

mkdir media
mkdir media/pictures
mkdir media/videos
mkdir media/music

mkdir workspace
mkdir workspace/templates

xdg-user-dir-update --set DOCUMENTS $HOME/gdrive
xdg-user-dir-update --set PICTURES $HOME/media/pictures
xdg-user-dir-update --set VIDEOS $HOME/media/videos
xdg-user-dir-update --set MUSIC $HOME/media/music
xdg-user-dir-update --set TEMPLATES $HOME/workspace/templates

#this makes java use system anti-aliased fonts and make swing use the GTK look and feel
echo "export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel'" >> etc/profile.d/jre.sh

################# Setup Code ############################
#########################################################
code --install-extension ${code_setup[*]}
#add git directory for firefox, set to setup firefox here

#################### Setup Workspace ################################
#####################################################################

cd workspace

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