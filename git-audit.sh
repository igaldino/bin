#!/bin/sh

echo FILENAME,CREATED BY,CREATION DATE,MODIFIED BY,MODIFIED DATE
for i in `git ls-files`
do
	LASTCOMMIT=`git log -1 --pretty=format:"%ae,%ad" -- $i`
	FIRSTCOMMIT=`git log -1 --pretty=format:"%ae,%ad" --diff-filter=A -- $i`
	echo $i,$FIRSTCOMMIT,$LASTCOMMIT
done
