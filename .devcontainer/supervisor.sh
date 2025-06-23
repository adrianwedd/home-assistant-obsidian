#!/bin/bash
# shellcheck shell=bash disable=SC2155
set -eE

SUPERVISOR_VERSON="$(curl -s https://version.home-assistant.io/dev.json | jq -e -r '.supervisor')"
DOCKER_TIMEOUT=30
DOCKER_PID=0

function start_docker() {
    local starttime
    local endtime

    if grep -q 'Alpine|standard-WSL' /proc/version; then
        update-alternatives --set iptables /usr/sbin/iptables-legacy || echo "Fails adjust iptables"
        update-alternatives --set ip6tables /usr/sbin/iptables-legacy || echo "Fails adjust ip6tables"
    fi

    echo "Starting docker."
    dockerd 2> /dev/null &
    DOCKER_PID=$!

    echo "Waiting for docker to initialize..."
    starttime="$(date +%s)"
    endtime="$(date +%s)"
    until docker info >/dev/null 2>&1; do
        if [ $((endtime - starttime)) -le $DOCKER_TIMEOUT ]; then
            sleep 1
            endtime=$(date +%s)
        else
            echo "Timeout while waiting for docker to come up"
            exit 1
        fi
    done
    echo "Docker was initialized"
}

function stop_docker() {
    if [ -n "$DOCKER_PID" ]; then
        echo "Stopping docker..."
        kill "$DOCKER_PID"
        local starttime="$(date +%s)"
        local endtime="$(date +%s)"
        while kill -0 "$DOCKER_PID" >/dev/null 2>&1; do
            if [ $((endtime - starttime)) -le $DOCKER_TIMEOUT ]; then
                sleep 1
                endtime="$(date +%s)"
            else
                echo "Timeout while waiting for dockerd to stop"
                break
            fi
        done
    fi
}

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
        ghcr.io/home-assistant/amd64-hassio-supervisor:"${SUPERVISOR_VERSON}"
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

start_docker
trap "stop_docker" ERR

docker system prune -f

cleanup_lastboot
cleanup_docker
init_dbus
init_udev
run_supervisor
stop_docker
