FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    openssh-server \
    mosh \
    irssi \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -m -s /bin/bash m && \
    mkdir -p /home/m/.ssh && \
    mkdir -p /run/sshd

COPY authorized_keys /home/m/.ssh/authorized_keys
COPY sshd_config /etc/ssh/sshd_config

RUN chown -R m:m /home/m/.ssh && \
    chmod 700 /home/m/.ssh && \
    chmod 600 /home/m/.ssh/authorized_keys && \
    chmod 600 /etc/ssh/sshd_config && \
    ssh-keygen -A

EXPOSE 22 60000-61000/udp

CMD ["/usr/sbin/sshd", "-D", "-e"]
