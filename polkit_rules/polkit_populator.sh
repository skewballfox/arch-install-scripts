#!/bin/bash
echo 'populating polkit rules'

rules_location='/etc/polkit-1/rules.d/'


for file in polkit_rules/*.rules; do
  if [[ $file != *"populator"* ]]; then
      base_file=$(echo $(basename "$file") )
      cp -i "polkit_rules/$base_file" $rules_location$base_file
  fi
done
