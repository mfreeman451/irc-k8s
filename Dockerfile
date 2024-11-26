FROM debian:bullseye

# Install required packages
RUN apt-get update && apt-get install -y \
    mosh \
    irssi \
    openssh-server \
    openssh-client \
    procps \
    sudo \
    iproute2 \
    iputils-ping \
    dnsutils \
    curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create user and required directories
RUN useradd -u 1000 -m -s /bin/bash m && \
    mkdir -p /home/m/.ssh /run/sshd && \
    chown -R m:m /home/m && \
    chmod 700 /home/m/.ssh

# Generate host keys
RUN ssh-keygen -A

# Copy entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 22 60000-61000/udp

ENTRYPOINT ["/entrypoint.sh"]