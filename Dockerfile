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
    zsh \
    python2.7 \
    python2.7-dev \
    python-dbg \
    python-pil \
    #python-imaging \
    python-pycryptopp \
    python-pyside \
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
    #libssl-dev \
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
    php \
    libreadline-dev \
    libconfig-dev \
    libssl1.0-dev \
    lua5.2 liblua5.2-dev \
    libevent-dev \
    libjansson-dev \
    libpython-dev \
    lldb \
    htop \
    wine-stable \
    steghide \
    xxd \
	bison \
	flex \
	libtool \
	libprotobuf-dev \
	protobuf-compiler \
	yarn \
    unzip


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

## Other python cool pip modules
RUN python2 -m pip install --force-reinstall pip \
    && python2 -m pip install --upgrade r2pipe \
    && python2 -m pip install --upgrade Pillow \
    && python2 -m pip install --upgrade distorm3 \
    && python2 -m pip install --upgrade pycrypto \
    && python2 -m pip install --upgrade psutil \
    && python2 -m pip install --upgrade pyelftools 

RUN python3 -m pip install --force-reinstall pip \
    && python3 -m pip install --upgrade r2pipe \
    && python3 -m pip install --upgrade Pillow \
    && python3 -m pip install --upgrade distorm3 \
    && python3 -m pip install --upgrade pycrypto \
    && python3 -m pip install --upgrade psutil \
    && python3 -m pip install --upgrade pyelftools 
 
## Install Pwntools
RUN python2 -m pip install --upgrade git+https://github.com/Gallopsled/pwntools.git
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

## Install tg-cli
RUN git clone --recursive https://github.com/vysheng/tg.git /home/re/tools/tg \
    && cd /home/re/tools/tg \
    && ./configure \
    && make

## Install radare2
#RUN git clone https://github.com/radare/radare2 /home/re/tools/radare2 \
#    && cd /home/re/tools/radare2 \
#    && ./sys/install.sh
RUN apt-get install -y radare2

RUN python3 -m pip install angr

## Install ROPGadget
RUN python2 -m pip install ropgadget
RUN python3 -m pip install ropgadget

## Install neovim
RUN add-apt-repository ppa:neovim-ppa/unstable \
	&& apt-get update \
	&& apt-get install -y neovim

## Install node
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash \
	&& apt-get update \
	&& apt-get install -y nodejs

## Install yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
	&& echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
	&& apt-get update \
	&& apt-get install -y yarn

EXPOSE 22 1337 8080 3002 3003 4000
USER re
WORKDIR /home/re

## Install rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/home/re/.cargo/bin:${PATH}"

## Install wasabi
#RUN git clone https://github.com/danleh/wasabi /home/re/tools/wasabi \
#    && cd /home/re/tools/wasabi \
#    && cargo install --path .

CMD ["/bin/bash", "-i"]

