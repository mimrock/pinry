#!/bin/bash
# -----------------------------------------------------------------------------
# docker-pinry /start script
#
# Will setup database and static files if they don't exist already, if they do
# just continues to run docker-pinry.
#
# Authors: Isaac Bythewood
# Updated: Aug 19th, 2014
# -----------------------------------------------------------------------------
set -e

PROJECT_ROOT="/pinry"

bash ${PROJECT_ROOT}/docker/scripts/bootstrap.sh

# If static files don't exist collect them
cd ${PROJECT_ROOT}
python manage.py collectstatic --noinput

# Apply pending migrations for both new and existing databases.
cd ${PROJECT_ROOT}
python manage.py migrate --noinput

# Fix all settings after all commands are run
chown -R www-data:www-data /data

# start all process
/usr/sbin/nginx

cd ${PROJECT_ROOT}
exec ./docker/scripts/_start_gunicorn.sh
