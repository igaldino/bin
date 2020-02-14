#!/bin/bash
. ~/etc/duplicity/bkp-setup.sh
duplicity collection-status ${GD_REMOTE_FOLDER}

