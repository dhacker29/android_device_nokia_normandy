#!/bin/sh

MYABSPATH=$(readlink -f "$0")
PATCHBASE=$(dirname "$MYABSPATH")
ANDROIDBASE=$(readlink -f "$PATCHBASE/../../../../")

for i in $(find "$PATCHBASE"/* -type d); do
	PATCHNAME=$(basename "$i")
	PATCHTARGET=$PATCHNAME
	for i in $(seq 4); do
		PATCHTARGET=$(echo $PATCHTARGET | sed 's/_/\//')
		if [ -d "$ANDROIDBASE/$PATCHTARGET" ]; then break; fi
	done
	echo applying $PATCHNAME to $PATCHTARGET
	cd "$ANDROIDBASE/$PATCHTARGET" || exit 1
	git am -3 "$PATCHBASE/$PATCHNAME"/* || exit 1
done
