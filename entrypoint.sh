#!/usr/bin/env bash
set -e

# Don't touch this unless you know what your doing!
export XDG_RUMTIME_DIR=/tpm/runtime-vulnarch
mkdir -p "XDG_RUNTIME_DIR"
chmod 700 "XDG_RUNTIME_DIR"

# Start the plasma desktop (can be accessed using the same vulnerable VNC)
su - vulnarch -c "startplasma-wayland" &

# Wait 5 second's after starting the desktop
sleep 5

# Vulnerable VNC Server Desktop (plasma-desktop)
su - vulnarch -c "wayvnc -C config/wayvnc/config"
