#!/usr/bin/env bash
# edit this only if you know what you are doing!
set -e

# Vulnerable VNCSERVER
mkdir -p /home/vulnarch/.vnc
chown -R vulnarch:vulnarch /home/vulnarch/.vnc
echo "vulnarch" | vncpasswd -f > /home/vulnarch/.vnc/passwd
chown vulnarch:vulnarch /home/vulnarch/.vnc/passwd
chmod 600 /home/vulnarch/.vnc/passwd
su - vulnarch -c "vncserver :1 -geometry 1280x720 -depth 24 -localhost no"
tail -f /home/vulnarch/.vnc/*.log
