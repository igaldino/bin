#!/bin/sh

MYNAME=`hostname -s`
HDDBKP=/run/media/isaque/disk3/bkp/${MYNAME}
NETBKP=/net/barney/home/media/bkp/${MYNAME}
SYNCOM="rsync --delete --delete-excluded --exclude=.* --exclude=lost+found -av"
LSTFLG=-n
NETFLG=-z
DIRLST=/home/
HDDNET=hdd
COMMIT=false
QUIETY=false

if [ "${MYNAME}" == "fred" ]; then
	:
elif [ "${MYNAME}" == "slate" ]; then
	DIRLST=/home/ /projects/
else
	echo "I don't recognize this box!"
	echo "I only support fred and slate."
	exit 0;
fi

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
	esac
done

if [ "${HDDNET}" == "hdd" ]; then
	echo "Changes from: ${DIRLST}"
 	echo "          to: ${HDDBKP}"
	${SYNCOM} ${LSTFLG} ${DIRLST} ${HDDBKP}

	if [ "${COMMIT}" == "true" ]; then
		if [ "${QUIETY}" == "false" ]; then
			read -p "Press ENTER to continue or CTRL-C to stop."
		fi
		${SYNCOM} ${DIRLST} ${HDDBKP}
	fi

elif [ "${HDDNET}" == "net" ]; then
	echo "Changes from: ${DIRLST}"
 	echo "          to: ${NETBKP}"
	echo ${SYNCOM} ${LSTFLG} ${NETFLG} ${DIRLST} ${NETBKP}
	${SYNCOM} ${LSTFLG} ${NETFLG} ${DIRLST} ${NETBKP}

	if [ "${COMMIT}" == "true" ]; then
		if [ "${QUIETY}" == "false" ]; then
			read -p "Press ENTER to continue or CTRL-C to stop."
		fi
		${SYNCOM} ${NETFLG} ${DIRLST} ${NETBKP}
	fi
fi
