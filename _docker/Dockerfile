# Zachary Goldstein

#===----------------------------------------------------------------------===//

# Stage 1. grab the LLVM source code
FROM debian:bullseye-slim as llvm_builder
LABEL maintainer "Zachary Goldstein <zgoldy00@gmail.com>"
ARG DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get -qq  update  && \
    apt-get -qqy upgrade && \
    apt-get -qqy install  --no-install-suggests --no-install-recommends \
        gnupg2 \
        lsb-release \
        software-properties-common \
        wget && \
    rm -rf /var/lib/apt/lists/* && \
    rm -r /var/cache/apt

RUN wget https://apt.llvm.org/llvm.sh && \
    chmod +x llvm.sh && \
    ./llvm.sh 13 && \
    rm llvm.sh

#===----------------------------------------------------------------------===//

# Stage 2. Produce a minimal release image with build results.
FROM llvm_builder as opam_builder
LABEL maintainer "Zachary Goldstein <zgoldy00@gmail.com>"

# Install additional dependencies
RUN apt-get -qq  update  && \
    apt-get -qqy upgrade && \
    apt-get -qqy install  --no-install-suggests --no-install-recommends \
        build-essential \
        cmake \
        curl \
        make \
        patch \
        unzip && \
    rm -rf /var/lib/apt/lists/* && \
    rm -r /var/cache/apt

RUN echo /usr/bin | \
    bash -c "sh <(curl -fsSL https://raw.githubusercontent.com/ocaml/opam/master/shell/install.sh)"

RUN mkdir -p /home/dev/.opam
RUN opam init --disable-sandboxing --root=/home/dev/.opam
RUN opam install llvm ocamlbuild ocamlfind --yes --root=/home/dev/.opam

#===----------------------------------------------------------------------===//

# Stage 3. Produce a minimal release image with build results.
FROM llvm_builder as final
LABEL maintainer "Zachary Goldstein <zgoldy00@gmail.com>"

RUN apt-get -qq  update  && \
    apt-get -qqy upgrade && \
    apt-get -qqy install  --no-install-suggests --no-install-recommends \
        build-essential \
        make \
        valgrind && \
    rm -rf /var/lib/apt/lists/* && \
    rm -r /var/cache/apt

# Remove libraries from llvm_builder that are no longer necessary
RUN apt-get -qq  update  && \
    apt-get -qqy upgrade && \
    apt-get -qqy purge  \
        gnupg2 \
        lsb-release \
        software-properties-common \
        wget && \
    apt-get  -qqy autoremove && \
    rm -rf /var/lib/apt/lists/* && \
    rm -r /var/cache/apt

COPY ll_links.sh .
RUN ./ll_links.sh && rm ll_links.sh

ADD .bashrc /.bashrc
RUN cat .bashrc > /root/.bashrc && rm .bashrc
RUN echo "PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u\[\033[00m\]:\[\033[01;34m\]\W\[\033[00m\]\$ '" >> /etc/bash.bashrc
RUN echo 'root:root' | chpasswd

RUN useradd -ms /bin/bash dev
RUN echo 'dev:dev' | chpasswd
COPY --from=opam_builder --chown=dev /home/dev/.opam/ /home/dev/.opam/
COPY --from=opam_builder /usr/bin/opam /usr/bin/

USER dev
WORKDIR /home/dev
RUN echo "test -r /home/dev/.opam/opam-init/init.sh && . /home/dev/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true" >> ~/.bashrc
RUN echo "PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u\[\033[00m\]:\[\033[01;34m\]\W\[\033[00m\]\$ '" >> ~/.bashrc
RUN echo 'PATH="/usr/links:$PATH"' >> ~/.bashrc
RUN echo 'set -o ignoreeof' >> ~/.bashrc 

