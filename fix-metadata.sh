#!/bin/bash

IFS='
'

for i in $@; do
  ffmpeg -i "${i}" -metadata Title="" -codec copy "New ${i}"
done

