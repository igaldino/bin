#!/bin/bash

MYNAME=`hostname -s`
MYUSER=`whoami`
HDDBKP=/media/${MYUSER}/disk3/backups/${MYNAME}/${MYUSER}
NETBKP=barney:/home/media/backups/${MYNAME}/${MYUSER}
SYNCOM="rsync --delete --delete-excluded --include=.git --include=.gitconfig --include=.gitignore --include=.minecraft --include=.minetest --include=.config --include=.config/Genymobile --include=.config/openttd --include=.config/VirtualBox --include=.config/gnome-boxes --include=.local --include=.local/share --include=.local/share/gnome-boxes --include=.local/share/openttd --include=.config/lutris --include=.local/share/lutris --include=.local/share/Steam --include=.openttd --include=.steam --include=.steampath --include=.steampid --include=.var --include=.var/app --include=.var/app/info.febvre.Komikku --include=.var/app/com.mojang.Minecraft --include=.var/app/org.openttd.OpenTTD --include=.var/app/org.tlauncher.TLauncher --include=.wine --include=.Genymobile --exclude=.* --exclude=.config/* --exclude=.local/* --exclude=.local/share/* --exclude=.var/* --exclude=.var/app/* --exclude=lost+found --exclude=ISOs -av"
LSTFLG=-n
NETFLG=-z
DIRLST=/home/${MYUSER}/
HDDNET=hdd
COMMIT=false
QUIETY=false
PIDFIL=/tmp/backup-${MYUSER}.pid

for i in $@; do
	case ${i} in
		hdd|net)
			HDDNET=${i}
			;;
		commit)
			COMMIT=true
			;;
		quiet)
			QUIETY=true
			;;
		force)
			rm ${PIDFIL}
			;;
	esac
done

if [ -f ${PIDFIL} ]; then
	echo "Process `cat ${PIDFIL}` is already running."
	exit 1
fi

echo ${$} > ${PIDFIL}

if [ "${HDDNET}" == "hdd" ]; then
	if [ ! -d ${HDDBKP} ]; then
		# /media failed
		HDDBKP=/run${HDDBKP}
		if [ ! -d ${HDDBKP} ]; then
			# /run/media failed too
			echo "Please connect USB drive in ${HDDBKP}."
			rm ${PIDFIL}
			exit 1
		fi
	fi

	if [ "${QUIETY}" == "false" ]; then
		echo "Changes from: ${DIRLST}"
 		echo "          to: ${HDDBKP}"
		echo "     Command: ${SYNCOM} ${LSTFLG} ${DIRLST} ${HDDBKP}"
		${SYNCOM} ${LSTFLG} ${DIRLST} ${HDDBKP}
	fi

	if [ "${COMMIT}" == "true" ]; then
		if [ "${QUIETY}" == "false" ]; then
			read -p "Press ENTER to continue or CTRL-C to stop."
		fi
		${SYNCOM} ${DIRLST} ${HDDBKP}
	fi

elif [ "${HDDNET}" == "net" ]; then
	if [ "${QUIETY}" == "false" ]; then
		echo "Changes from: ${DIRLST}"
 		echo "          to: ${NETBKP}"
		echo "     Command: ${SYNCOM} ${LSTFLG} ${NETFLG} ${DIRLST} ${NETBKP}"
		${SYNCOM} ${LSTFLG} ${NETFLG} ${DIRLST} ${NETBKP}
	fi

	if [ "${COMMIT}" == "true" ]; then
		if [ "${QUIETY}" == "false" ]; then
			read -p "Press ENTER to continue or CTRL-C to stop."
		fi
		${SYNCOM} ${NETFLG} ${DIRLST} ${NETBKP}
	fi
fi

rm ${PIDFIL}

