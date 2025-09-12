# Base on the most populat clang image (since there's no official one).
# https://hub.docker.com/r/silkeh/clang

ARG VERSION=17
FROM silkeh/clang:$VERSION

# Install cmake and git
RUN apt-get -q update && \
    apt-get install -y --no-install-recommends \
    cmake=3.25.1-1 \
    git=1:2.39.5-0+deb12u2 \
    && \
    rm -rf /var/cache/apt/archives /var/lib/apt/lists/*
