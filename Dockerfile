FROM debian:bullseye

# Install required packages
RUN apt-get update && apt-get install -y \
    mosh \
    irssi \
    openssh-server \
    sudo \
    && apt-get clean

# Create non-root user
RUN useradd -m -s /bin/bash m && \
    mkdir -p /home/m/.ssh && \
    chown -R m:m /home/m && \
    mkdir -p /run/sshd && \
    echo "m ALL=(ALL) NOPASSWD: /usr/sbin/ssh-keygen" >> /etc/sudoers

# Create a backup directory for SSH config that the non-root user can access
RUN mkdir -p /home/m/ssh-backup && \
    chown m:m /home/m/ssh-backup

# Configure SSH
COPY --chown=m:m sshd_config /home/m/ssh-backup/sshd_config
COPY --chown=m:m authorized_keys /home/m/.ssh/authorized_keys
COPY --chown=m:m entrypoint.sh /entrypoint.sh

RUN chmod 600 /home/m/.ssh/authorized_keys && \
    chmod 600 /home/m/ssh-backup/sshd_config && \
    chmod +x /entrypoint.sh

# Expose ports
EXPOSE 22
EXPOSE 60000-61000/udp

# Set entrypoint
ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]