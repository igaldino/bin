#!/bin/bash

HOST=`hostname -s`
MYUSER=`whoami`

rclone sync --stats-one-line -v --skip-links \
  $HOME box:bkp/${HOST} \
  --exclude=.cache/** \
  --exclude=.config/** \
  --exclude=**/.git/** \
  --exclude=.local/** \
  --exclude=.mozilla/** \
  --exclude=.steam/** \
  --exclude=.var/** \
  --exclude=.wine/** \
  --exclude=**/builddir/** \
  --exclude=**/java-runtime/**

