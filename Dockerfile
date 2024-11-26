FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    openssh-server \
    mosh \
    irssi \
<<<<<<< HEAD
=======
    openssh-server \
    openssh-client \
    procps \
    sudo \
    iproute2 \
    iputils-ping \
    dnsutils \
    curl \
    nano \
    vim \
    less \
    net-tools \
    && apt-get clean \
>>>>>>> 48fcf7f (🔧 udpating dockerfile)
    && rm -rf /var/lib/apt/lists/*

RUN useradd -m -s /bin/bash m && \
    mkdir -p /home/m/.ssh && \
    mkdir -p /run/sshd

COPY authorized_keys /home/m/.ssh/authorized_keys
COPY sshd_config /etc/ssh/sshd_config

RUN chown -R m:m /home/m/.ssh && \
    chmod 700 /home/m/.ssh && \
    chmod 600 /home/m/.ssh/authorized_keys && \
<<<<<<< HEAD
    chmod 600 /etc/ssh/sshd_config && \
    ssh-keygen -A
=======
    chmod 600 /home/m/ssh-backup/sshd_config && \
    chmod +x /entrypoint.sh
>>>>>>> 48fcf7f (🔧 udpating dockerfile)

EXPOSE 22 60000-61000/udp

CMD ["/usr/sbin/sshd", "-D", "-e"]
