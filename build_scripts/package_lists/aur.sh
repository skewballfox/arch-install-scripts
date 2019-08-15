build_aur=(yay -Sya --nocombinedupgrade --noconfirm --sudoloop)
# for working with android projects via android studio
build_aur+=(android-studio-beta android-sdk android-docs android-sdk-platform-tools)
# a few installs for making this build unixporn worthy
build_aur+=(i3lock-fancy-git oh-my-zsh-git oh-my-zsh-powerline-theme-git otf-nerd-fonts-fira-code)
# for interfacing with cloud services and personal libraries
build_aur+=(drive-bin buku bukubrow)
# for using git with pass
build_aur+=(pass-git-helper-git)
# why isn't this in available via the official repositories?
build_aur+=(rstudio-desktop-bin)
# to check java style with kak
build_aur+=(checkstyle)
# system hardening
build_aur+=(hardened-malloc-git)