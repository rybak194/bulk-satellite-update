#!/bin/sh
# example usages:
# bash satellite-update.sh pw.esn.pl // standard run with site as parameter
# bash satellite-update.sh pw.esn.pl latest_package.tgz //optional parameter: package name
# bash satellite-update.sh pw.esn.pl 2>&1 | tee satellite-update.log // writes output to log file
# bash satellite-update.sh pw.esn.pl 2>&1 | tee >(ts "%d-%m-%y %H:%M:%S" > satellite-update.log) //writes output to log file with timestamp

SITE=$1
RELATIVE_PACKAGE_PATH=${2:-"latest_package.tgz"}

PACKAGE_PATH=$(readlink -f $RELATIVE_PACKAGE_PATH)
SITE_DIR="/var/www/$SITE/web"
DIR_OWNER=$(stat -c '%U' $SITE_DIR)

echo -e "********************** $SITE_DIR | $DIR_OWNER *******************************"

if [ ! -d "$SITE_DIR" ]; then
  echo -e "$SITE_DIR - does not exist" && exit 1
fi

if [ ! -f "$PACKAGE_PATH" ]; then
  echo -e "$PACKAGE_PATH - does not exist" && exit 1
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
   echo -e "Database migration failed" && exit 1
fi

drush vset --exact maintenance_mode 0
drush cache-clear all
echo "Disabled maintenance mode"

echo -e "$SITE - update finished successfully"
