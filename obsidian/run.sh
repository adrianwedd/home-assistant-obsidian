#!/usr/bin/with-contenv bashio
# shellcheck shell=bash disable=SC2155
set -e



# Export user-provided options
export PUID="$(bashio::config 'puid')"
export PGID="$(bashio::config 'pgid')"
export TZ="$(bashio::config 'tz')"

exec /init
