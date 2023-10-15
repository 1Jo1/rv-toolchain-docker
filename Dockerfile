FROM ubuntu:20.04

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
    python3

RUN cd /riscv/ && ./configure --prefix=/opt/riscv --enable-multilib
RUN cd /riscv/ && make linux -j4
RUN rm -rf /riscv

RUN DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt-get install -y wget tar software-properties-common python3.9 python3-venv python3-pip
RUN pip3 install sphinx
# RUN add-apt-repository -y ppa:deadsnakes/ppa
# RUN apt-get update
# RUN apt install python3.9
RUN wget https://download.qemu.org/qemu-8.1.1.tar.xz
RUN tar xvJf qemu-8.1.1.tar.xz
RUN cd qemu-8.1.1 && ./configure --target-list=riscv64-softmmu && make -j $(nproc) && make install

USER riscv
WORKDIR /home/riscv
