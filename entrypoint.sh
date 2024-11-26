#!/bin/bash
set -e

echo "Starting SSH server setup..."

# Ensure runtime directory has correct permissions
chown root:root /run/sshd
chmod 755 /run/sshd

# Ensure .ssh directory exists with correct permissions
mkdir -p /home/m/.ssh
chown m:m /home/m/.ssh
chmod 700 /home/m/.ssh

# Set authorized_keys permissions if it exists
if [ -f "/home/m/.ssh/authorized_keys" ]; then
    chmod 600 /home/m/.ssh/authorized_keys
    chown m:m /home/m/.ssh/authorized_keys
fi

echo "Starting sshd..."
exec /usr/sbin/sshd -D -e