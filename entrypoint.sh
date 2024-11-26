cat > entrypoint.sh << 'EOF'
#!/bin/bash

echo "Starting entrypoint script..."

# Check and create SSH directory if it doesn't exist
echo "Checking SSH directory..."
if [ ! -d "/etc/ssh" ]; then
    sudo mkdir -p /etc/ssh
    sudo chown m:m /etc/ssh
fi
echo "Created /etc/ssh directory"

# Copy sshd_config if it doesn't exist
if [ ! -f "/etc/ssh/sshd_config" ]; then
    echo "Copying sshd_config from backup..."
    cp /home/m/ssh-backup/sshd_config /etc/ssh/sshd_config
    chmod 600 /etc/ssh/sshd_config
fi

# Generate SSH host keys if they don't exist
if [ ! -f "/etc/ssh/ssh_host_rsa_key" ]; then
    echo "Generating SSH host keys..."
    sudo ssh-keygen -A
    sudo chown -R m:m /etc/ssh/
fi

echo "Starting SSH daemon..."
echo "SSH directory contents:"
ls -la /etc/ssh/
echo "Content of sshd_config:"
cat /etc/ssh/sshd_config

exec /usr/sbin/sshd -D -e
EOF

chmod +x entrypoint.sh