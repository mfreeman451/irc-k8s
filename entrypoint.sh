#!/bin/bash
set -e

echo "Starting SSH server setup..."

# Ensure runtime directory has correct permissions
chown root:root /run/sshd
chmod 755 /run/sshd

# Create a writable .ssh directory in home
mkdir -p /home/m/.ssh
chown m:m /home/m/.ssh
chmod 700 /home/m/.ssh

# Copy authorized_keys from mounted ConfigMap to writable location
if [ -f "/config/authorized_keys" ]; then
    cp /config/authorized_keys /home/m/.ssh/authorized_keys
    chmod 600 /home/m/.ssh/authorized_keys
    chown m:m /home/m/.ssh/authorized_keys
fi

echo "Starting sshd..."
exec /usr/sbin/sshd -D -e