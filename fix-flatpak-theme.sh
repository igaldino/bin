#!/bin/bash

for i in ~/.var/app/*; do
  mkdir -p ${i}/config/gtk-3.0 2>/dev/null
  ln -s ~/.config/gtk-3.0/settings.ini ${i}/config/gtk-3.0/. 2>/dev/null 
done

