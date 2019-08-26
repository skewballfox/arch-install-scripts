################# Run stuff that required rebooting ######
##########################################################

git config --global credential.helper /usr/lib/git-core/git-credential-libsecret


################# Setup Firefox ##########################
##########################################################

cp -R firefox-tweaks/chrome  ~/.mozilla/*firefox*/*.default/

################# Setup Code ############################
#########################################################

source $HOME/workspace/System_Tools/arch-install-scripts/build_scripts/package_lists/code_oss.sh

code --install-extension ${code_setup[*]}

################# Setup Google drive ####################
#########################################################



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

########################## Install Rust ############################
####################################################################

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

########################## Clean Up ################################
####################################################################

sudo rm -r /build_scripts
rm $0