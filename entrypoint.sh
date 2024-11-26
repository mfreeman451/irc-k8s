#!/bin/bash

echo "Starting entrypoint script..."

# Check and create SSH directory if it doesn't exist
echo "Checking SSH directory..."
mkdir -p /etc/ssh
echo "Created /etc/ssh directory"

# Copy sshd_config from backup location if it doesn't exist in /etc/ssh
if [ ! -f /etc/ssh/sshd_config ]; then
    echo "Copying sshd_config from backup..."
    cp /etc/sshd_config.backup /etc/ssh/sshd_config
    chmod 600 /etc/ssh/sshd_config
fi

# Generate SSH host keys if they don't exist
if [ ! -f /etc/ssh/ssh_host_rsa_key ]; then
    echo "Generating SSH host keys..."
    ssh-keygen -A
fi

echo "Starting SSH daemon..."
ls -la /etc/ssh/
echo "Content of sshd_config:"
cat /etc/ssh/sshd_config

exec /usr/sbin/sshd -D -e
