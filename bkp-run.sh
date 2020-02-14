#!/bin/bash
. ~/etc/duplicity/bkp-setup.sh
duplicity \
	--include-filelist ${GD_FILELIST} \
	${GD_LOCAL_FOLDER} \
	${GD_REMOTE_FOLDER}

