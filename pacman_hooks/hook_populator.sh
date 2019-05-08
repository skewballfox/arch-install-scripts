#!/bin/bash

rules_location='/etc/pacman.d/hooks/'
current_directory=$(pwd)

vga_driver=$(lspci | grep 'vga\|3d\|2d')

for file in $current_directory/*.hook; do
  if [[ $file != *"populator"* ]]; then
      base_file=$(echo $(basename "$file") )
      if [[ $base_file != *"nvidia"* ]]; then
        echo $base_file
        sudo cp -i "$(pwd)/$base_file" $rules_location$base_file
      else
        if [[ $vga_driver = *"Nvidia"* ]]; then
          echo yeet
          # sudo cp -i "$(pwd)/$base_file" $rules_location$base_file
        fi
      fi
  fi
done
