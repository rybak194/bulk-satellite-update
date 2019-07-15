#!/bin/sh
# example usages:
# bash bulk-satellite-update.sh
# bash bulk-satellite-update.sh 2>&1 | tee bulk-satellite-update.log // writes output to log file
# bash bulk-satellite-update.sh 2>&1 | tee >(ts "%d-%m-%y %H:%M:%S" > bulk-satellite-update.log) //writes output to log file with timestamp

declare -a SITES_ARRAY=(sekcja1.esn.pl
sekcja2.esn.pl
sekcja3.esn.pl)

for SITE in "${SITES_ARRAY[@]}"
do
	if bash satellite-update.sh $SITE; then
		echo -e "$SITE - update finished successfully"
	else
	   echo -e "$SITE - update failed"
	fi
done
