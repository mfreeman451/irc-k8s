#!/bin/bash

set -x  # Enable debug output

echo "Starting entrypoint script..."

# Setup basic directories
mkdir -p /etc/ssh
mkdir -p /home/m/.ssh
mkdir -p /run/sshd

# Basic sshd config
cat > /etc/ssh/sshd_config <<EOL
Port 22
AddressFamily any
ListenAddress 0.0.0.0
ListenAddress ::

Protocol 2
HostKey /etc/ssh/ssh_host_rsa_key
HostKey /etc/ssh/ssh_host_ecdsa_key
HostKey /etc/ssh/ssh_host_ed25519_key

PubkeyAuthentication yes
PasswordAuthentication no
ChallengeResponseAuthentication no
PermitRootLogin no

UsePAM yes
X11Forwarding no
PrintMotd no

AcceptEnv LANG LC_*
Subsystem sftp /usr/lib/openssh/sftp-server

AllowUsers m
StrictModes no

AuthorizedKeysFile .ssh/authorized_keys
LogLevel DEBUG3
EOL

# Generate host keys if needed
if [ ! -f "/etc/ssh/ssh_host_rsa_key" ]; then
    ssh-keygen -A
fi

# Set permissions
chown -R root:root /etc/ssh
chmod 755 /etc/ssh
chmod 644 /etc/ssh/ssh_host_*.pub
chmod 600 /etc/ssh/ssh_host_*_key
chmod 600 /etc/ssh/sshd_config

chown -R m:m /home/m
chmod 755 /home/m
chown -R m:m /home/m/.ssh
chmod 700 /home/m/.ssh
chmod 600 /home/m/.ssh/authorized_keys

# Start sshd
exec /usr/sbin/sshd -D -e