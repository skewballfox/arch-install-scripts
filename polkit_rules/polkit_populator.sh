#!/bin/bash

rules_location='/etc/polkit-1/rules.d/'
current_directory=$(pwd)

for file in $current_directory/*.rules; do
  if [[ $file != *"populator"* ]]; then
      base_file=$(echo $(basename "$file") )
      sudo cp -i "$(pwd)/$base_file" $rules_location$base_file
  fi
done
