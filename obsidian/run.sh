#!/usr/bin/with-contenv bashio
set -e

# Symlink /data to /config to match linuxserver.io's expected data path.
if [ ! -L /config ]; then
  bashio::log.info "/config is not a symlink. Re-linking to /data..."
  rm -rf /config
  ln -s /data /config
fi

# Export user-provided options
export PUID="$(bashio::config 'puid')"
export PGID="$(bashio::config 'pgid')"
export TZ="$(bashio::config 'tz')"

exec /init

