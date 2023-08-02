#!/bin/bash

HOST=`hostname -s`
MYUSER=`whoami`

rclone sync --stats-one-line -v --skip-links \
  ${HOME} box:bkp/${HOST} \
  --exclude=**/.angular/** \
  --exclude=bkp/** \
  --exclude=**/builddir/** \
  --exclude=.cache/** \
  --exclude=.certponto/** \
  --exclude=.cisco/** \
  --exclude=.config/** \
  --exclude=eclipse/** \
  --exclude=**/.git/** \
  --exclude=**/java-runtime/** \
  --exclude=.local/** \
  --exclude=.m2/** \
  --exclude=.mozilla/** \
  --exclude=node_modules/** \
  --exclude=.npm/** \
  --exclude=.steam/** \
  --exclude=.var/** \
  --exclude=.vscode/** \
  --exclude=**/WebSphere/** \
  --exclude=.wine/** \

