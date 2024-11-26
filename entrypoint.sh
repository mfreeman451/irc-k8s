#!/bin/bash

set -x  # Enable debug output

echo "Starting entrypoint script..."

# Create sshd config
cat > /etc/ssh/sshd_config <<EOL
Port 22
Protocol 2
AddressFamily any
ListenAddress 0.0.0.0
ListenAddress ::
PermitRootLogin no
PubkeyAuthentication yes
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

# For debugging
SyslogFacility AUTH

# More permissive key settings
PubkeyAcceptedKeyTypes=+ssh-ed25519
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

# Ensure home directory structure
mkdir -p /home/m/.ssh
chown -R m:m /home/m
chmod 755 /home/m
chown -R m:m /home/m/.ssh
chmod 700 /home/m/.ssh
[ -f /home/m/.ssh/authorized_keys ] && chmod 600 /home/m/.ssh/authorized_keys

# Start sshd with debug mode
exec /usr/sbin/sshd -D -d -e