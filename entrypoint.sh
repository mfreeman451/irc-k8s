#!/bin/bash

set -x  # Enable debug output

echo "Starting entrypoint script..."

# Create sshd config
cat > /etc/ssh/sshd_config <<EOL
Port 22
AddressFamily any
ListenAddress 0.0.0.0
ListenAddress ::
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

# Generate host keys if needed
if [ ! -f "/etc/ssh/ssh_host_rsa_key" ]; then
    ssh-keygen -A
fi

# Ensure proper ownership of SSH files
chown -R root:root /etc/ssh/
chmod 755 /etc/ssh
chmod 644 /etc/ssh/ssh_host_*.pub
chmod 600 /etc/ssh/ssh_host_*_key

# Start sshd with debug mode
exec /usr/sbin/sshd -D -e