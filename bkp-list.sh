#!/bin/bash
. ~/etc/duplicity/bkp-setup.sh
duplicity list-current-files ${GD_REMOTE_FOLDER}

