FROM ubuntu:22.04

ARG UID=1000

RUN addgroup riscv && useradd -m -g riscv -u ${UID} riscv

ENV PATH /opt/riscv/bin:${PATH}

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt-get install -y git

RUN git clone https://github.com/riscv/riscv-gnu-toolchain --recursive /riscv/

RUN DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt-get install -y \
    autoconf \
    automake \
    autotools-dev \
    curl \
    libmpc-dev \
    libmpfr-dev  \
    libgmp-dev  \
    gawk  \
    build-essential  \
    bison  \
    flex  \
    texinfo  \
    gperf  \
    libtool  \
    patchutils  \
    bc  \
    zlib1g-dev  \
    libexpat-dev \
    python3 \
    wget \
    tar \
    software-properties-common \
    python3.9 \
    python3-venv \
    python3-pip \
    ninja-build \
    pkg-config \
    glib2.0 \
    libpixman-1-dev


RUN cd /riscv/ && ./configure --prefix=/opt/riscv --enable-multilib
RUN cd /riscv/ && make linux -j4
RUN rm -rf /riscv

RUN pip3 install sphinx sphinx-rtd-theme
RUN wget https://download.qemu.org/qemu-8.1.1.tar.xz
RUN tar xvJf qemu-8.1.1.tar.xz
RUN cd qemu-8.1.1 && ./configure --target-list=riscv64-softmmu && make -j $(nproc) && make install
RUN rm -rf qemu-8.1.1

USER riscv
WORKDIR /home/riscv
