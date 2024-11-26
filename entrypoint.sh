#!/bin/bash

set -x  # Enable debug output

echo "Starting entrypoint script..."

# Generate host keys if needed (only if directory is empty)
if [ ! -f "/etc/ssh/ssh_host_rsa_key" ]; then
    ssh-keygen -A
fi

# Ensure SSH directory exists with correct permissions
mkdir -p /home/m/.ssh
chown -R m:m /home/m/.ssh
chmod 700 /home/m/.ssh
chmod 600 /home/m/.ssh/authorized_keys

# Start sshd with debug mode
exec /usr/sbin/sshd -D -d