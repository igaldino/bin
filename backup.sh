#!/bin/sh

MYNAME=`hostname -s`
MYUSER=`whoami`
HDDBKP=/run/media/${MYUSER}/disk3/bkp/${MYNAME}/${MYUSER}
NETBKP=barney:/home/media/bkp/${MYNAME}/${MYUSER}
SYNCOM="rsync --delete --delete-excluded --exclude=.* --exclude=lost+found -av"
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

