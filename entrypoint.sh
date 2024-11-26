#!/bin/bash

# Enable error handling
set -e
set -o pipefail

# Handle signals
trap 'kill -TERM $PID' TERM INT

echo "Starting entrypoint script..."

# Debug system info
echo "System Information:"
uname -a
id
pwd

# Debug binaries
echo "Binary locations:"
which sshd || true
which ssh-keygen || true
ls -la /usr/sbin/sshd || true
ls -la /usr/bin/ssh-keygen || true

# Setup SSH directory
echo "Setting up SSH directory..."
mkdir -p /etc/ssh
chmod 755 /etc/ssh

# Debug SSH directory
echo "SSH directory contents before setup:"
ls -la /etc/ssh/

# Copy config if not exists
echo "Setting up sshd_config..."
cp -v /home/m/ssh-backup/sshd_config /etc/ssh/sshd_config
chmod 600 /etc/ssh/sshd_config

# Generate host keys if needed
echo "Checking host keys..."
if [ ! -f "/etc/ssh/ssh_host_rsa_key" ]; then
    echo "Generating host keys..."
    /usr/bin/ssh-keygen -A || /usr/sbin/ssh-keygen -A
fi

# Set permissions
echo "Setting permissions..."
chown -R m:m /home/m/.ssh
chmod 700 /home/m/.ssh
chmod 600 /home/m/.ssh/authorized_keys

# Debug final state
echo "Final SSH directory contents:"
ls -la /etc/ssh/
echo "sshd_config contents:"
cat /etc/ssh/sshd_config

# Test config
echo "Testing sshd configuration..."
/usr/sbin/sshd -t
echo "sshd configuration test passed"

# Start sshd
echo "Starting sshd..."
exec /usr/sbin/sshd -D -e