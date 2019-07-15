#!/bin/sh

SITE=$1
RELATIVE_PACKAGE_PATH=${2:-"latest_package.tgz"}

PACKAGE_PATH=$(readlink -f $RELATIVE_PACKAGE_PATH)
PROFILES_PATH="/root/satellite-update/esn.pl/esnpl_profiles.zip"
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

echo "Unpacking profiles $PROFILES_PATH in $SITE_DIR ..."
unzip -o $PROFILES_PATH -d $SITE_DIR

echo "Changing web directory owner to $DIR_OWNER ..."
chown -R $DIR_OWNER $SITE_DIR

echo "Register views-view–members_in_group.css..."
echo -e "\nstylesheets[all][] = css/views-view--members_in_group.css" >> "profiles/satellite/themes/esnsatellite/esnsatellite.info"

echo "Applying database migrations..."
if drush updatedb -y; then
   echo "Database migrated"
else
   echo -e "\e[31mDatabase migration failed\e[0m" && exit 1
fi

drush vset --exact maintenance_mode 0
drush cache-clear all
echo "Disabled maintenance mode"

echo -e "\e[92m$SITE - update finished successfully \e[0m"
