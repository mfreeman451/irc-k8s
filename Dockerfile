FROM debian:bullseye

# Install required packages
RUN apt-get update && apt-get install -y \
    mosh \
    irssi \
    openssh-server \
    procps \
    && apt-get clean

# Create non-root user
RUN useradd -m -s /bin/bash m && \
    mkdir -p /home/m/.ssh && \
    chown -R m:m /home/m && \
    mkdir -p /run/sshd

# Create a backup directory for SSH config
RUN mkdir -p /home/m/ssh-backup

# Configure SSH
COPY sshd_config /home/m/ssh-backup/sshd_config
COPY authorized_keys /home/m/.ssh/authorized_keys
COPY entrypoint.sh /entrypoint.sh

RUN chown m:m /home/m/.ssh/authorized_keys && \
    chown m:m /home/m/ssh-backup/sshd_config && \
    chmod 600 /home/m/.ssh/authorized_keys && \
    chmod 600 /home/m/ssh-backup/sshd_config && \
    chmod +x /entrypoint.sh

# Expose ports
EXPOSE 22
EXPOSE 60000-61000/udp

# Set entrypoint
ENTRYPOINT ["/entrypoint.sh"]