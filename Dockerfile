# VulnArch - small, intentionally vulnerable Arch Linux lab
# Make changes only if you know what you are doing.
ENV LANG=C.UTF-8

# Install Dependencies
RUN pacman -Syu --noconfirm --needed \
      openssh apache php \
      tigervnc novnc websockify \
      plasma-desktop plasma-x11-session kwin-x11 konsole dolphin \
      xorg-xauth xorg-xrdb xorg-xsetroot xorg-xprop ttf-dejavu \
      rsyslog tcpdump dbus sudo procps-ng iproute2 net-tools inetutils nano \
    && pacman -Scc --noconfirm

# Syslogs
RUN <<'EOF2'
cat > /etc/rsyslog.conf <<'RSYS'
module(load="imuxsock")
$FileCreateMode 0640
auth,authpriv.*                    /var/log/auth.log
*.*;auth,authpriv.none             /var/log/syslog
RSYS
EOF2

# SSH weak
RUN <<'EOF2'
mkdir -p /etc/ssh/sshd_config.d
cat > /etc/ssh/sshd_config.d/00-lab.conf <<'SSH'
PermitRootLogin yes
PasswordAuthentication yes
PubkeyAuthentication yes
UsePAM yes
MaxAuthTries 20
LogLevel VERBOSE
SSH
EOF2

# Weak Website
RUN <<'EOF2'
set -e
CONF=/etc/httpd/conf/httpd.conf
sed -i 's|^LoadModule mpm_event_module|#LoadModule mpm_event_module|' "$CONF"
sed -i 's|^#\(LoadModule mpm_prefork_module\)|\1|' "$CONF"
cat >> "$CONF" <<'APACHE'

ServerName localhost
LoadModule php_module modules/libphp.so
AddHandler php-script .php
Include conf/extra/php_module.conf
DirectoryIndex index.php index.html
APACHE
sed -i 's/^display_errors.*/display_errors = On/' /etc/php/php.ini
EOF2

# Command injection
RUN <<'EOF2'
cat > /srv/http/index.php <<'PHP'
<!doctype html>
<title>ws-corp-01 - Network Tools</title>
<body style="font-family:sans-serif;max-width:640px;margin:40px auto">
<h2>ws-corp-01 — Internal Network Tools</h2>
<p>Ping a host on the LAN:</p>
<form method="GET">
  <input name="host" value="<?php echo isset($_GET['host']) ? htmlspecialchars($_GET['host']) : '127.0.0.1'; ?>">
  <button type="submit">Ping</button>
</form>
<?php
if (isset($_GET['host']) && $_GET['host'] !== '') {
    // VULNERABLE: user input passed straight to shell_exec, no sanitization
    $cmd = "ping -c 3 " . $_GET['host'];
    echo "<pre>" . shell_exec($cmd) . "</pre>";
}
?>
</body>
PHP
chown -R http:http /srv/http
EOF2

# Copy files to container
COPY entrypoint.sh /entrypoint.sh
# Make it executable
RUN chmod +x /entrypoint.sh
# Expose ports to host machine
EXPOSE 22 80 5901 6080

ENTRYPOINT ["/entrypoint.sh"]
