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
		echo -e "\e[92m$SITE - update finished successfully \e[0m"
	else
	   echo -e "\e[31m$SITE - update failed\e[0m"
	fi
done
