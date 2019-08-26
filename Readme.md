# Arch install scripts

## Description

This automates the building/recreation of my current setup in arch, both in terms of downloaded packages and in terms of changes I have made to the setup. It also serves as a form of documentation that I can refer to when trying to see what changes I have made to my system.

## TODO

store variables in files to pass options between scripts

setup a few useful Virtual Machines

Migrate to a custom Kernel

mv optimal block size check into installer itself

implement logging to catch possible errors and misteps

Move all non-essential packages to main package list, and leave all essential packages in base package list

look into and implement compilation flags for certain packages ( considering trying to get native performance for electron. )

review and move all non-essential packages from base to user script to improve install time (low priority)

use tmux to daemonize termite

figure out how to update rsync server list in powerpill config

explore battery saving options

make the partition management a bit more flexible

Find a way to sandbox x11 for Firefox while retaining the ability to control the window shape via i3wm (qubes managed to do this with xen virtualization)