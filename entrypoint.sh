#!/usr/bin/env bash
set -e
VNC_PASSWORD="${VNC_PASSWORD:-password}"
mkdir -p /home/user/.vnc
echo "$VNC_PASSWORD" | vncpasswd -f > /home/user/.vnc/passwd
chown -R user:user /home/user/.vnc
chmod 600 /home/user/.vnc/passwd
dbus-uuidgen --ensure=/etc/machine-id
dbus-daemon --system --fork 2>/dev/null
install -d -m 700 -o user -g user /tmp/run-user
su user -c "Xvnc :1 -geometry 1280x800 -depth 24 -rfbport 5901 -rfbauth /home/user/.vnc/passwd -SecurityTypes VncAuth -AlwaysShared" &
XVNC_PID=$!
for i in $(seq 15); do [ -S /tmp/.X11-unix/X1 ] && break; sleep 1; done
su user -c "DISPLAY=:1 XDG_RUNTIME_DIR=/tmp/run-user dbus-run-session -- startplasma-x11" &
echo "VNC ready -> password: $VNC_PASSWORD"
wait "$XVNC_PID"
