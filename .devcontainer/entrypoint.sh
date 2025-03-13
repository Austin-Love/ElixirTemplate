#!/bin/sh
set -e

# This is the entrypoint script for dev only docker container running the app
# in order to make sure additional dependencies are installed when running the app.

mix deps.get

npm --prefix /app/assets install

exec "$@"
