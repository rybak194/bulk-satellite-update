#!/bin/sh

SITE=$1
USER=$2

SITE_DIR="/var/www/$SITE/web"

echo -e "\e[93m********************** $SITE_DIR | $USER *******************************\e[0m"

cd $SITE_DIR
drush vset --exact maintenance_mode 1
drush cache-clear all
echo "Enabled maintenance mode"

echo "Removing files..."
rm -rf profiles themes scripts modules misc includes && rm -f *

echo "Copying satellite package files..."
cp /root/update-test/latest_package.tgz $SITE_DIR

echo "Unpacking satellite package..."
tar xfz latest_package.tgz --strip-components=1

echo "Removing satellite package..."
rm -f latest_package.tgz

echo "Applying database migrations..."
if drush updatedb -y; then
   echo "Database migrated"
else
   echo -e "\e[31m$SITE - database migration failed\e[0m" && exit 1
fi

echo "Changing web directory ownership..."
chown -R $USER $SITE_DIR

drush vset --exact maintenance_mode 0
drush cache-clear all
echo "Disabled maintenance mode"

echo -e "\e[92m$SITE - update finished successfully \e[0m"
