#!/bin/bash

BASIC="com.github.calo001.fondo org.gnome.Notes org.gtk.Gtk3theme.Arc-Dark org.gtk.Gtk3theme.Arc-Darker org.keepassxc.KeePassXC org.libreoffice.LibreOffice org.mozilla.firefox"
DEVEL="com.visualstudio.code org.eclipse.Java org.gnome.Builder org.gnome.gitg org.gnome.meld"
GAMES="com.endlessnetwork.aqueducts com.mojang.Minecraft com.play0ad.zeroad com.valvesoftware.Steam net.minetest.Minetest org.supertuxproject.SuperTux"
LEARN="edu.mit.Scratch"
MEDIA="com.obsproject.Studio com.spotify.Client fr.handbrake.ghb info.febvre.Komikku org.audacityteam.Audacity org.kde.kdenlive"
OTHER="com.skype.Client org.gnome.Boxes org.gnome.Fractal org.telegram.desktop"

# Firefox Font Fix
FFFFX="${HOME}/.var/app/org.mozilla.firefox/config/fontconfig/fonts.conf"

if [ ${#} -eq 0 ]
then
	echo "Usage: ${0} <basic | devel | games | learn | media | other>"
	echo "  basic: ${BASIC}"
	echo "  devel: ${DEVEL}"
	echo "  games: ${GAMES}"
	echo "  learn: ${LEARN}"
	echo "  media: ${MEDIA}"
	echo "  other: ${OTHER}"
	exit 1
fi

PACKS="${BASIC}"
DEVPK=false
for i in $@; do
	case ${i} in
		devel)
			PACKS="${PACKS} ${DEVEL}"
			DEVPK=true
			;;
		games)
			PACKS="${PACKS} ${GAMES}"
			;;
		learn)
			PACKS="${PACKS} ${LEARN}"
			;;
		media)
			PACKS="${PACKS} ${MEDIA}"
			;;
		other)
			PACKS="${PACKS} ${OTHER}"
			;;
	esac
done

flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install -y flathub ${PACKS}

if [ ${DEVPK} == "true" ]
then
  flatpak remote-add --if-not-exists gnome-nightly https://nightly.gnome.org/gnome-nightly.flatpakrepo
  flatpak install -y gnome-nightly org.gnome.Sdk org.gnome.Platform
fi

if [ ! -f ${FFFFX} ]
then
  mkdir -p ${FFFFX%/*}
cat<<EOF | tee ${FFFFX}
<?xml version='1.0'?>
<!DOCTYPE fontconfig SYSTEM 'fonts.dtd'>
<fontconfig>
  <!-- Disable bitmap fonts. -->
  <selectfont>
    <rejectfont>
      <pattern>
        <patelt name="scalable">
          <bool>false</bool>
        </patelt>
      </pattern>
    </rejectfont>
  </selectfont>
</fontconfig>
EOF
fi
