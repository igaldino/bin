#!/bin/bash

MYNAME=`hostname -s`
MYUSER=`whoami`
HDDBKP=/media/${MYUSER}/disk3/bkp/${MYNAME}/${MYUSER}/
NETBKP=barney:/home/media/bkp/${MYNAME}/${MYUSER}/
SYNCOM="rsync -av"
LSTFLG=-n
NETFLG=-z
DIRLST=/home/${MYUSER}
HDDNET=hdd
COMMIT=false
QUIETY=false
PIDFIL=/tmp/restore-${MYUSER}.pid

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
			echo "Please connect USB drive."
			exit 1
		fi
	fi

	if [ "${QUIETY}" == "false" ]; then
		echo "Changes from: ${HDDBKP}"
 		echo "          to: ${DIRLST}"
		echo "     Command: ${SYNCOM} ${LSTFLG} ${HDDBKP} ${DIRLST}"
		${SYNCOM} ${LSTFLG} ${HDDBKP} ${DIRLST}
	fi

	if [ "${COMMIT}" == "true" ]; then
		if [ "${QUIETY}" == "false" ]; then
			read -p "Press ENTER to continue or CTRL-C to stop."
		fi
		${SYNCOM} ${HDDBKP} ${DIRLST}
	fi

elif [ "${HDDNET}" == "net" ]; then
	if [ "${QUIETY}" == "false" ]; then
		echo "Changes from: ${NETBKP}"
 		echo "          to: ${DIRLST}"
		echo "     Command: ${SYNCOM} ${LSTFLG} ${NETFLG} ${NETBKP} ${DIRLST}"
		${SYNCOM} ${LSTFLG} ${NETFLG} ${NETBKP} ${DIRLST}
	fi

	if [ "${COMMIT}" == "true" ]; then
		if [ "${QUIETY}" == "false" ]; then
			read -p "Press ENTER to continue or CTRL-C to stop."
		fi
		${SYNCOM} ${NETFLG} ${NETBKP} ${DIRLST}
	fi
fi

rm ${PIDFIL}

