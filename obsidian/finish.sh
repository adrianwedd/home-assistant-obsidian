#!/usr/bin/with-contenv bashio
# shellcheck shell=bash

# Send SIGTERM to the VNC server
s6-svscanctl -t /var/run/s6/services/kasmvnc
