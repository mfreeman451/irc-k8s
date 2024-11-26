FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    openssh-server \
    mosh \
    irssi \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -m -s /bin/bash m && \
    mkdir -p /home/m/.ssh /run/sshd && \
    chown -R m:m /home/m && \
    chmod 700 /home/m/.ssh

EXPOSE 22 60000-61000/udp

CMD ["/usr/sbin/sshd", "-D", "-e"]