#!/bin/bash

set -x  # Enable debug output

echo "Starting entrypoint script..."

# Ensure SSH directories exist
mkdir -p /etc/ssh
mkdir -p /home/m/.ssh

# Copy sshd_config if it doesn't exist
if [ ! -f "/etc/ssh/sshd_config" ]; then
    cat > /etc/ssh/sshd_config <<EOL
Port 22
PermitRootLogin no
PubkeyAuthentication yes
PasswordAuthentication no
ChallengeResponseAuthentication no
UsePAM yes
X11Forwarding yes
PrintMotd no
AcceptEnv LANG LC_*
Subsystem sftp /usr/lib/openssh/sftp-server
AllowUsers m
StrictModes no
EOL
fi

# Generate host keys if needed
if [ ! -f "/etc/ssh/ssh_host_rsa_key" ]; then
    ssh-keygen -A
fi

# Set proper permissions
chown -R m:m /home/m
chmod 700 /home/m/.ssh
touch /home/m/.ssh/authorized_keys
chmod 600 /home/m/.ssh/authorized_keys
chown m:m /home/m/.ssh/authorized_keys

# Set correct permissions for SSH host keys
chmod 644 /etc/ssh/ssh_host_*.pub
chmod 600 /etc/ssh/ssh_host_*_key

# Start sshd with debug mode
exec /usr/sbin/sshd -D -d