FROM debian:bullseye

# Install required packages
RUN apt-get update && apt-get install -y \
    mosh \
    irssi \
    openssh-server \
    && apt-get clean

# Create non-root user
RUN useradd -m -s /bin/bash m && \
    mkdir -p /home/m/.ssh && \
    chown -R m:m /home/m && \
    mkdir /run/sshd

# Configure SSH
COPY sshd_config /etc/ssh/sshd_config
COPY authorized_keys /home/m/.ssh/authorized_keys
RUN chown m:m /home/m/.ssh/authorized_keys && \
    chmod 600 /home/m/.ssh/authorized_keys

# Expose ports
EXPOSE 22
EXPOSE 60000-61000/udp

# Start SSH server and bash
CMD ["/usr/sbin/sshd", "-D"]