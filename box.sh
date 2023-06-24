#!/bin/bash

HOST=`hostname -s`
MYUSER=`whoami`

rclone sync --stats-one-line -v --skip-links \
  ${HOME} box:bkp/${HOST} \
  --exclude=bkp/** \
  --exclude=**/builddir/** \
  --exclude=.cache/** \
  --exclude=.config/** \
  --exclude=**/.git/** \
  --exclude=**/java-runtime/** \
  --exclude=.local/** \
  --exclude=.m2/** \
  --exclude=.mozilla/** \
  --exclude=node_modules/** \
  --exclude=.npm/** \
  --exclude=.steam/** \
  --exclude=.var/** \
  --exclude=.wine/** \

