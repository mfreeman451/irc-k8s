#!/bin/bash

set -x  # Enable debug output

echo "Starting entrypoint script..."

# Debug SSH directory and authorized_keys
echo "Checking user SSH directory:"
ls -la /home/m/.ssh/
echo "Checking authorized_keys content:"
cat /home/m/.ssh/authorized_keys

# Setup SSH directory
mkdir -p /etc/ssh
chmod 755 /etc/ssh

# Copy config
cp -v /home/m/ssh-backup/sshd_config /etc/ssh/sshd_config
chmod 600 /etc/ssh/sshd_config

# Generate host keys if needed
if [ ! -f "/etc/ssh/ssh_host_rsa_key" ]; then
    ssh-keygen -A
fi

# Set strict permissions
chown -R m:m /home/m/.ssh
chmod 700 /home/m/.ssh
chmod 600 /home/m/.ssh/authorized_keys
chown m:m /home/m/.ssh/authorized_keys

# Start sshd with debug mode
exec /usr/sbin/sshd -D -d
