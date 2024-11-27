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
    tmux \
    vim \
    locales \
    && rm -rf /var/lib/apt/lists/*

# Configure locales
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && \
    locale-gen && \
    echo "LANG=en_US.UTF-8" > /etc/default/locale

# Create user with proper shell and sudo access
RUN useradd -m -s /bin/bash m && \
    echo "m:changeme" | chpasswd && \
    usermod -aG sudo m && \
    mkdir -p /home/m/.ssh /run/sshd && \
    chown -R m:m /home/m && \
    chmod 700 /home/m/.ssh && \
    echo "m ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/m

# Add default tmux config
RUN echo '\n\
# Enable mouse control\n\
set -g mouse on\n\
\n\
# Change prefix to Ctrl-a\n\
set -g prefix C-a\n\
unbind C-b\n\
bind C-a send-prefix\n\
\n\
# Start window numbering at 1\n\
set -g base-index 1\n\
\n\
# Automatic window renaming\n\
set-window-option -g automatic-rename on\n\
\n\
# Status bar customization\n\
set -g status-bg black\n\
set -g status-fg white\n\
\n\
# Highlight active window\n\
set-window-option -g window-status-current-style bg=red\n\
\n\
# Increase scrollback buffer size\n\
set -g history-limit 10000\n\
\n\
# Enable vi mode\n\
set-window-option -g mode-keys vi\n\
' > /home/m/.tmux.conf && \
    chown m:m /home/m/.tmux.conf

# Generate host keys
RUN ssh-keygen -A

# Set environment variables
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

EXPOSE 22 60000-61000/udp

CMD ["/usr/sbin/sshd", "-D", "-e"]