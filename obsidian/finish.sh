#!/usr/bin/with-contenv bashio

# Send SIGTERM to the VNC server
s6-svscanctl -t /var/run/s6/services/kasmvnc
