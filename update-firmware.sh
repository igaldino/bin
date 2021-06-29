#!/bin/bash

fwupdmgr get-devices
fwupdmgr refresh
fwupdmgr get-updates

COMMIT=false
for i in $@
do
  case ${i} in
    commit)
      COMMIT=true
      ;;
  esac
done

if [ "${COMMIT}" == "true" ]
then
  fwupdmgr update
fi
