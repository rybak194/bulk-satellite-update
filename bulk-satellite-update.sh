#!/bin/sh
# example usages:
# bash bulk-satellite-update.sh

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