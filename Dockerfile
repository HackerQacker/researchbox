# boogy/ctfbox
FROM ubuntu:latest
MAINTAINER OmerYe

ENV DEBIAN_FRONTEND noninteractive
RUN dpkg --add-architecture i386 \
    && apt-get update \
    && apt-get install -yq software-properties-common \
    && apt-get update \
    && apt-get -yq install \
    build-essential \
    python2.7 \
    python2.7-dev \
    python-dbg \
    python-pil \
    #python-imaging \
    python-pycryptopp \
    python-pyside \
    python-dev \
    python-dev \
    python-pip \
    python-virtualenv \
    virtualenvwrapper \
    python3 \
    python3-pip \
    python3-dev \
    libqt4-dev \
    libxml2-dev \
    libxslt1-dev \
    libgraphviz-dev \
    libjpeg8 \
    libjpeg62-dev \
    libfreetype6 \
    libfreetype6-dev \
    apt-utils \
    default-jre \
    libboost-all-dev \
    git \
    sudo \
    p7zip \
    autoconf \
    libssl-dev \
    libpcap-dev \
    libffi-dev \
    libqt4-dev \
    graphviz-dev \
    cmake \
    clang \
    llvm \
    nasm \
    tmux \
    gdb \
    gdb-multiarch \
    gdbserver \
    foremost \
    ipython \
    ipython3 \
    stow \
    virtualenvwrapper \
    ltrace \
    strace \
    socat \
    tcpdump \
    john \
    hydra \
    vim \
    curl \
    wget \
    nmap \
    gcc-multilib \
    g++-multilib \
    netcat \
    openssh-server \
    openssh-client \
    lsof \
    libc6:i386 \
    libncurses5:i386 \
    libstdc++6:i386 \
    libc6-dev-i386 \
    squashfs-tools \
    apktool \
    android-tools-adb \ 
    android-tools-fastboot \ 
    libimage-exiftool-perl \
    qemu \
    qemu-user \
    qemu-user-static \
    man \
    upx \
    php

## install golang latest
RUN add-apt-repository ppa:longsleep/golang-backports \
    && apt-get update \
    && apt-get install -yq golang-go

## super root password
RUN /bin/echo -e "toor\ntoor"|passwd root

## setup a user
RUN useradd -m -s /bin/bash re \
    && usermod -aG sudo re \
    && /bin/echo -e "re\nre"|passwd re \
    && chmod 4750 /home/re \
    && mkdir -p /home/re/tools \
    && chown -R re: /home/re \
    && mkdir -p /etc/sudoers.d \
    && echo "re ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/re \
    && echo "kernel.yama.ptrace_scope = 0" > /etc/sysctl.d/10-ptrace.conf, \
    && sysctl -p

## TODO: Add dotfiles

## Other python cool pip modules
RUN python2 -m pip install --force-reinstall pip \
    #&& pip2 install --upgrade pip \
    && pip2 install --upgrade r2pipe \
    && pip2 install --upgrade Pillow \
    && pip2 install --upgrade distorm3 \
    && pip2 install --upgrade pycrypto \
    && pip2 install --upgrade psutil \
    && pip2 install --upgrade pyelftools \
    && pip2 install --upgrade git+https://github.com/hellman/xortool.git

## Install Pwntools
RUN pip install --upgrade git+https://github.com/Gallopsled/pwntools.git
RUN python3 -m pip install --upgrade git+https://github.com/Gallopsled/pwntools.git@dev3

## Install peda
RUN git clone https://github.com/longld/peda.git /home/re/tools/peda \
    && /bin/echo -en "define load_peda\n  source /home/re/tools/peda/peda.py\nend\n" >> /home/re/.gdbinit \
    && echo "alias peda='gdb -ex load_peda'" >> /home/re/.bash_aliases

## Install pwndbg
RUN git clone https://github.com/pwndbg/pwndbg.git /home/re/tools/pwndbg \
    && cd /home/re/tools/pwndbg \
    && ./setup.sh \
    && /bin/echo -en "\ndefine load_pwndbg\n  source /home/re/tools/pwndbg/gdbinit.py\nend\n" >> /home/re/.gdbinit \
    && echo "alias pwndbg='gdb -ex load_pwndbg'" >> /home/re/.bash_aliases


## Install capstone
RUN git clone https://github.com/aquynh/capstone /home/re/tools/capstone \
    && cd /home/re/tools/capstone \
    && ./make.sh \
    && ./make.sh install \
    && cd /home/re/tools/capstone/bindings/python \
    && python3 setup.py install \
    && python2 setup.py install

## Install radare2
#RUN git clone https://github.com/radare/radare2 /home/re/tools/radare2 \
#    && cd /home/re/tools/radare2 \
#    && ./sys/install.sh
RUN apt-get install -y radare2

RUN pip2 install angr

## Install ROPGadget
RUN git clone https://github.com/JonathanSalwan/ROPgadget /home/re/tools/ROPgadget \
    && cd /home/re/tools/ROPgadget \
    && python setup.py install

EXPOSE 22 1337 3002 3003 4000
USER re
WORKDIR /home/re

## Install rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/home/re/.cargo/bin:${PATH}"

## Install wasabi
RUN git clone https://github.com/danleh/wasabi /home/re/tools/wasabi \
    && cd /home/re/tools/wasabi \
    && cargo install --path .

## Install some tmux conf
RUN git clone https://github.com/samoshkin/tmux-config.git \
    && ./tmux-config/install.sh

## Add my ctf volume

CMD ["/usr/bin/tmux"]
#CMD ["/bin/bash", "-i"]

