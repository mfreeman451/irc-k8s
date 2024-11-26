#!/bin/bash

# Check and create SSH directory if it doesn't exist
mkdir -p /etc/ssh

# Generate SSH host keys if they don't exist
if [ ! -f /etc/ssh/ssh_host_rsa_key ]; then
    ssh-keygen -A
fi

# Start SSH daemon
exec /usr/sbin/sshd -D -e
