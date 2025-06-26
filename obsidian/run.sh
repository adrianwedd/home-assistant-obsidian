#!/usr/bin/with-contenv bashio
set -e

# Symlink /data to /config to match linuxserver.io's expected data path.
if [ ! -L /config ]; then
  bashio::log.info "/config is not a symlink. Checking for existing data..."
  if [ -d /config ] && [ "$(ls -A /config)" ]; then
    bashio::log.info "Moving existing data from /config to /data..."
    cp -a /config/. /data/
    rm -rf /config
  fi
  bashio::log.info "Re-linking /config to /data..."
  ln -s /data /config
fi

# Export user-provided options
export PUID="$(bashio::config 'puid')"
export PGID="$(bashio::config 'pgid')"
export TZ="$(bashio::config 'tz')"

exec /init
