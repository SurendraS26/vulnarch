#!/usr/bin/env bash
set -e
VNC_PASSWORD="${VNC_PASSWORD:-vulnarch}"
mkdir -p /home/sonu/.vnc
echo "$VNC_PASSWORD" | vncpasswd -f > /home/sonu/.vnc/passwd
chown -R sonu:sonu /home/sonu/.vnc
chmod 600 /home/sonu/.vnc/passwd
dbus-uuidgen --ensure=/etc/machine-id
dbus-daemon --system --fork 2>/dev/null
install -d -m 700 -o user -g sonu /tpm/run-user
su sonu -c "Xvnc :1 -geometry 1280x800 -depth 24 -rfbport 5901 -rfbauth /home/user/.vnc/passwd -SecurityTypes VncAuth -AlwaysShared &"
sleep 2
su sonu -c "DISPLAY=:1 XDG_RUNTIME_DIR=/tmp/run-user dbus-run-session -- startplasma-x11 &"
echo "VNC ready -> password: $VNC_PASSWORD"
websockify --web /usr/share/webapps/novnc 6080 127.0.0.1:5901
