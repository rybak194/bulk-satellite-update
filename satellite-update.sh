#!/bin/sh

SITE=$1

PACKAGE_PATH="/root/satellite-update/latest_package.tgz"
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
drush vset --exact maintenance_mode 1
drush cache-clear all
echo "Enabled maintenance mode"

echo "Purging site directory: $SITE_DIR ..."
rm -rf profiles themes scripts modules misc includes
rm -f *

echo "Unpacking satellite package $PACKAGE_PATH in $SITE_DIR ..."
tar xfz $PACKAGE_PATH -C $SITE_DIR --strip-components=1

echo "Changing web directory owner to $DIR_OWNER ..."
chown -R $DIR_OWNER $SITE_DIR

echo "Applying database migrations..."
if drush updatedb -y; then
   echo "Database migrated"
else
   echo -e "\e[31mDatabase migration failed\e[0m" && exit 1
fi

drush vset --exact maintenance_mode 0
drush cache-clear all
echo "Disabled maintenance mode"

