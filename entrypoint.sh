#!/usr/bin/env bash
set -e

mkdir -p /home/vulnarch/.vnc
chown -R vulnarch:vulnarch /home/vulnarch/.vnc

echo "vulnarch" | vncpasswd -f > /home/vulnarch/.vnc/passwd
chown vulnarch:vulnarch /home/vulnarch/.vnc/passwd
chmod 600 /home/vulnarch/.vnc/passwd

su - vulnarch -c "vncserver :1 -geometry 1280x720 -depth 24 -localhost no"
tail -f /home/vulnarch/.vnc/*.log
