FROM debian:bullseye

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
    && rm -rf /var/lib/apt/lists/*

# Create user with proper shell and sudo access
RUN useradd -m -s /bin/bash m && \
    echo "m:changeme" | chpasswd && \
    usermod -aG sudo m && \
    mkdir -p /home/m/.ssh /run/sshd && \
    chown -R m:m /home/m && \
    chmod 700 /home/m/.ssh && \
    # Allow sudo without password
    echo "m ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/m

# Generate host keys
RUN ssh-keygen -A

# Set up SSH config
COPY sshd_config /etc/ssh/sshd_config
RUN chmod 644 /etc/ssh/sshd_config

EXPOSE 22 60000-61000/udp

CMD ["/usr/sbin/sshd", "-D", "-e"]