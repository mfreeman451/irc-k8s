#!/bin/bash

set -x  # Enable debug output

echo "Starting entrypoint script..."

# Ensure /etc/ssh exists and has correct permissions
echo "Setting up SSH directory..."
if [ ! -d "/etc/ssh" ]; then
    mkdir -p /etc/ssh
fi
chmod 755 /etc/ssh
chown -R m:m /etc/ssh

# Copy base config if it doesn't exist
if [ ! -f "/etc/ssh/sshd_config" ]; then
    echo "Copying sshd_config from backup..."
    cp /home/m/ssh-backup/sshd_config /etc/ssh/sshd_config
    chmod 600 /etc/ssh/sshd_config
    chown m:m /etc/ssh/sshd_config
fi

# Generate SSH host keys if they don't exist
if [ ! -f "/etc/ssh/ssh_host_rsa_key" ]; then
    echo "Generating SSH host keys..."
    /usr/bin/ssh-keygen -A
    chown -R m:m /etc/ssh
fi

echo "Directory listing of /etc/ssh:"
ls -la /etc/ssh/

echo "Content of sshd_config:"
cat /etc/ssh/sshd_config || echo "Failed to read sshd_config"

echo "Checking sshd status:"
/usr/sbin/sshd -T || echo "sshd config test failed"

echo "Starting SSH daemon..."
exec /usr/sbin/sshd -D -e
