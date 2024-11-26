#!/bin/bash

set -x  # Enable debug output

echo "Starting entrypoint script..."

# Setup SSH directory structure
mkdir -p /etc/ssh
mkdir -p /home/m/.ssh

# Move host keys to correct location if they exist in wrong place
mv /home/m/.ssh/ssh_host_* /etc/ssh/ 2>/dev/null || true

# Create sshd config in correct location
cat > /etc/ssh/sshd_config <<EOL
Port 22
Protocol 2
AddressFamily any
ListenAddress 0.0.0.0
ListenAddress ::
PermitRootLogin no
PubkeyAuthentication yes
AuthorizedKeysFile .ssh/authorized_keys
PasswordAuthentication no
ChallengeResponseAuthentication no
UsePAM no
AllowAgentForwarding yes
AllowTcpForwarding yes
X11Forwarding no
PrintMotd no
AcceptEnv LANG LC_*
Subsystem sftp /usr/lib/openssh/sftp-server
AllowUsers m
StrictModes no
LogLevel DEBUG3
EOL

# Generate host keys if needed
if [ ! -f "/etc/ssh/ssh_host_rsa_key" ]; then
    ssh-keygen -A
fi

# Set correct permissions
chown -R root:root /etc/ssh/
chmod 755 /etc/ssh
chmod 644 /etc/ssh/ssh_host_*.pub
chmod 600 /etc/ssh/ssh_host_*_key
chmod 600 /etc/ssh/sshd_config

# Set user directory permissions
chown -R m:m /home/m/.ssh
chmod 700 /home/m/.ssh
chmod 600 /home/m/.ssh/authorized_keys

# Remove any misplaced config files
rm -f /home/m/.ssh/sshd_config 2>/dev/null || true

# Start sshd with debug mode and in foreground
exec /usr/sbin/sshd -D -e