#!/bin/bash

IS_ADMIN=0
groups | grep -q '\badmins\b' && IS_ADMIN=1

stow bash
stow debian
stow emacs
stow git
stow gnome

# Gnome settings that don't lend themselves to Stow
gsettings set com.canonical.Unity.Lenses disabled-scopes "['more_suggestions-amazon.scope', 'more_suggestions-u1ms.scope', 'more_suggestions-populartracks.scope', 'music-musicstore.scope', 'more_suggestions-ebay.scope', 'more_suggestions-ubuntushop.scope', 'more_suggestions-skimlinks.scope']"

if [[ $IS_ADMIN == 1 ]]; then
    gsettings set org.gnome.desktop.background color-shading-type 'horizontal'
    gsettings set org.gnome.desktop.background secondary-color '#a06d00000000'
    gsettings set org.gnome.desktop.background primary-color '#69d000000000'
    gsettings set org.gnome.desktop.background picture-uri 'file:///usr/share/backgrounds/Savannah_Lilian_Blot_by_a_Blot_on_the_landscape.jpg'
else
    gsettings set org.gnome.desktop.background picture-uri "file://$HOME/.local/share/backgrounds/mccllstr1/McCllstrCustom.xml"
fi
