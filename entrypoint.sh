#!/bin/bash
set -ex

echo "Starting SSH server setup..."

# Ensure runtime directory has correct permissions
chown root:root /run/sshd
chmod 755 /run/sshd

# Setup SSH directory
mkdir -p /home/m/.ssh
chown m:m /home/m/.ssh
chmod 700 /home/m/.ssh

# Copy and verify authorized_keys
if [ -f "/config/authorized_keys" ]; then
    echo "=== Content of source authorized_keys ==="
    cat /config/authorized_keys
    echo "=== Copying authorized_keys ==="
    cp /config/authorized_keys /home/m/.ssh/authorized_keys
    echo "=== Setting permissions ==="
    chmod 600 /home/m/.ssh/authorized_keys
    chown m:m /home/m/.ssh/authorized_keys
    echo "=== Content of copied authorized_keys ==="
    cat /home/m/.ssh/authorized_keys
    echo "=== File permissions ==="
    ls -la /home/m/.ssh/
fi

echo "=== SSH Configuration ==="
cat /etc/ssh/sshd_config

echo "=== Testing sshd configuration ==="
/usr/sbin/sshd -t

echo "Starting sshd..."
exec /usr/sbin/sshd -D -e