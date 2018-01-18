#!/bin/sh

MYNAME=`hostname -s`
MYUSER=`whoami`
HDDBKP=/run/media/${MYUSER}/disk3/bkp/${MYNAME}
NETBKP=/net/barney/home/media/bkp/${MYNAME}
SYNCOM="rsync --delete --delete-excluded --exclude=.* --exclude=lost+found -av"
LSTFLG=-n
NETFLG=-z
DIRLST=/home/
HDDNET=hdd
COMMIT=false
QUIETY=false
PIDFIL=/tmp/backup.pid

if [ "${MYNAME}" == "fred" ]; then
	:
elif [ "${MYNAME}" == "betty" ]; then
	:
elif [ "${MYNAME}" == "slate" ]; then
	DIRLST=/home/ /projects/
else
	echo "I don't recognize this box!"
	echo "I only support fred and slate."
	exit 1;
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

rm ${PIDFIL}

