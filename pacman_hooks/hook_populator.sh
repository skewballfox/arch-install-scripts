#!/bin/bash

rules_location='/etc/pacman.d/hooks/'
current_directory=$(pwd)

for file in $current_directory/*.hook; do
  if [[ $file != *"populator"* ]]; then
      base_file=$(echo $(basename "$file") )
      sudo cp -i "$(pwd)/$base_file" $rules_location$base_file
  fi
done
