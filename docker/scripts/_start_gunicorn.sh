#!/bin/bash
set -e

# Each sync worker keeps its image-processing memory, so small deployments
# can lower GUNICORN_WORKERS. Other Gunicorn options can be supplied through
# Gunicorn's own GUNICORN_CMD_ARGS variable.
exec gunicorn pinry.wsgi -b 0.0.0.0:8000 -w "${GUNICORN_WORKERS:-4}" \
    --capture-output --timeout 30 \
    --user www-data --group www-data \
    --env DJANGO_SETTINGS_MODULE=pinry.settings.docker
