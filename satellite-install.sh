#!/bin/sh
# example usages:
# bash satelite-install.sh pw.esn.pl
# bash satelite-install.sh pw.esn.pl latest_package.tgz

SITE=$1
RELATIVE_PACKAGE_PATH=${2:-"latest_package.tgz"}

PACKAGE_PATH=$(readlink -f $RELATIVE_PACKAGE_PATH)
SITE_DIR="/var/www/$SITE/web"
DIR_OWNER=$(stat -c '%U' $SITE_DIR)

echo -e "\e[93m********************** $SITE_DIR | $DIR_OWNER *******************************\e[0m"

if [ ! -d "$SITE_DIR" ]; then
  echo -e "\e[31m$SITE_DIR - does not exist\e[0m" && exit 1
fi

if [ ! -f "$PACKAGE_PATH" ]; then
  echo -e "\e[31m$PACKAGE_PATH - does not exist\e[0m" && exit 1
fi

cd $SITE_DIR
rm -rf *

echo "Unpacking satellite package $PACKAGE_PATH in $SITE_DIR ..."
tar xfz $PACKAGE_PATH -C $SITE_DIR --strip-components=1

echo "Changing web directory owner to $DIR_OWNER ..."
chown -R $DIR_OWNER $SITE_DIR

echo -e "\e[92mFiles copied successfully. Visit $SITE to finish the installation process.\e[0m"
