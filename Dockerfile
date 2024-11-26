FROM debian:bullseye

# Install mosh, irssi, and other necessary tools
RUN apt-get update && apt-get install -y \
    mosh \
    irssi \
    && apt-get clean

# Expose the default Mosh UDP port range
EXPOSE 60000-61000/udp

# Default command is a bash shell
CMD ["/bin/bash"]

