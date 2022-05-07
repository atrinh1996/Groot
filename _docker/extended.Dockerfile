# Zachary Goldstein

#===----------------------------------------------------------------------===//

# Stage 1. grab the LLVM source code
FROM zegger/llvm-opam:latest
LABEL maintainer "Zachary Goldstein <zgoldy00@gmail.com>"
ARG DEBIAN_FRONTEND=noninteractive

USER root

# Install base dependencies
RUN apt-get -qq  update  && \
    apt-get -qqy upgrade && \
    apt-get -qqy install  --no-install-suggests --no-install-recommends \
        apt-utils \
        dialog \
        sudo

# Install additional dependencies
RUN apt-get -qqy install  --no-install-suggests --no-install-recommends \
        cmake \
        curl \
        gnupg2 \
        patch \
        unzip \
        vim \
        wget

# allows the dev user to run sudo without providing a password
# RUN echo "dev    ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/dev-nopasswd

# allows the dev user to run sudo with default password (dev)
RUN adduser dev sudo


USER dev

#===----------------------------------------------------------------------===//

