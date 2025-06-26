#!/bin/bash
# shellcheck shell=bash disable=SC2155
set -eE

SUPERVISOR_VERSION="$(curl -s https://version.home-assistant.io/dev.json | jq -e -r '.supervisor')"



function cleanup_lastboot() {
    mkdir -p /etc/docker
    echo '{}' > /etc/docker/daemon.json
}

function cleanup_docker() {
    echo "Clean up docker"
    docker system prune -af
}

function run_supervisor() {
    docker run --name hassio_supervisor \
        --privileged \
        --security-opt apparmor:unconfined \
        -v /run/dbus:/run/dbus:ro \
        -v /run/docker.sock:/run/docker.sock \
        -v supervisor-data:/data \
        -e SUPERVISOR_SHARE=/data \
        -e SUPERVISOR_NAME=hassio_supervisor \
        -e SUPERVISOR_MACHINE=qemux86-64 \
        -e HOMEASSISTANT_REPOSITORY=homeassistant/qemux86-64-homeassistant \
        ghcr.io/home-assistant/amd64-hassio-supervisor:"${SUPERVISOR_VERSION}"
}

function init_dbus() {
    if pgrep dbus-daemon; then
        echo "dbus already running"
        return 0
    fi
    echo "Startup dbus"
    rm -fr /var/run/dbus
    mkdir -p /var/run/dbus

    dbus-daemon --system --print-address
}

function init_udev() {
    if pgrep systemd-udevd; then
        echo "udev is running"
        return 0
    fi

    echo "Startup udev"
    mkdir -p /run/udev
    /lib/systemd/systemd-udevd --daemon
    sleep 3
    udevadm trigger && udevadm settle
}

echo "Start Test-Env"



docker system prune -f

cleanup_lastboot
cleanup_docker
init_dbus
init_udev
run_supervisor
