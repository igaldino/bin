#!/bin/bash

BRIGHTLIGHT=`which brightlight`
XBACKLIGHT=`which xbacklight`

if [ ${#} != "2" ]; then
	echo "Usage: ${0} <inc|dec> <value>"
	exit 1
fi

if [ -f ${BRIGHTLIGHT} ]; then
	case ${1} in
		inc)
			brightlight -p -i ${2}
			;;
		dec)
			brightlight -p -d ${2}
			;;
	esac
elif [ -f ${XBACKLIGHT} ]; then
	case ${1} in
		inc)
			xbacklight -inc ${2}
			;;
		dec)
			xbacklight -dec ${2}
			;;
	esac
fi

