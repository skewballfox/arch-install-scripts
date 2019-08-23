build_aur=(yay -Sya --nocombinedupgrade --noconfirm --sudoloop)
# for working with android projects via android studio
build_aur+=(android-studio-beta android-sdk android-docs android-sdk-platform-tools)
# a few installs for making this build unixporn worthy
build_aur+=(i3lock-fancy-git oh-my-zsh-git otf-nerd-fonts-fira-code)
# for interfacing with cloud services, messaging systems, and personal libraries
build_aur+=(drive-bin buku bukubrow signal)
# why isn't this in available via the official repositories?
build_aur+=(rstudio-desktop-bin)
# to check java style with kak
build_aur+=(checkstyle)
# system hardening
build_aur+=(hardened-malloc-git)
# for chrony and NetworkManager integration
build_aur+=(networkmanager-dispatcher-chrony)