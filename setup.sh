#!/bin/bash

if [ -z $(which stow) ]; then
    echo "$0: ERROR, you need GNU stow installed" >&2
    exit 1
fi

# Define some functions for convenience
configure() {
    echo "Configuring $1"
    stow $1
}

configure_if_present() {
    if [[ -x $(which $1) ]]; then
	configure $1
    else
	echo "$1 not present on this system"
    fi
}

# Learn more about the current user
IS_ADMIN=0
groups | grep -q '\badmins\b' && IS_ADMIN=1


# ----------------------------------------------------------------------------
# Perform simple configurations
configure bash
configure git

configure_if_present aspell
configure_if_present emacs

# ----------------------------------------------------------------------------
# Do more involved configurations

DIST=$(lsb_release -is)
if [[ "Ubuntu" == $DIST || "Debian" == $DIST ]]; then
    echo "Configuring distribution-specific features for $DIST"
    stow debian
else
    echo "No distribution-specific configuration for $DIST"
fi

if [[ -x $(which gsettings) ]]; then
    echo "Configuring settings for Gnome"
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
else
    echo Gnome does not appear to be installed
fi
