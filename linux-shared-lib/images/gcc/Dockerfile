# Base on official gcc image
# https://hub.docker.com/_/gcc

ARG VERSION=15
FROM gcc:$VERSION

# Install CMake
RUN apt-get -q update && \
    apt-get install -y --no-install-recommends \
    cmake=3.31.6-2 \
    && \
    rm -rf /var/cache/apt/archives /var/lib/apt/lists/*
