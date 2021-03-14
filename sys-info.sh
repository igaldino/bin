#!/bin/sh

if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit
fi

SERIAL_NUMBER=`dmidecode -t 1 | grep -i serial | sed 's/ *//'`
WINDOWS_KEY=`strings /sys/firmware/acpi/tables/MSDM | tail -1`

echo ${SERIAL_NUMBER}
echo "Windows key:" ${WINDOWS_KEY}

