FROM toliak/mtasa AS mtasa

FROM debian:9.9-slim

EXPOSE 22003/udp 22005/tcp 22126/udp

RUN useradd -ms /bin/bash mtasa
WORKDIR /home/mtasa

RUN apt-get -y update && \
    apt-get -y install  wget \
                        make \
                        gcc \
                        g++ \
                        zlib1g \
                        zlib1g-dev \
                        libffi-dev \
                        libssl-dev \ 
                        && \
    mkdir -p /tmp/python && \
    cd /tmp/python && \
    wget https://www.python.org/ftp/python/3.7.6/Python-3.7.6.tgz && \
    tar xzf Python-3.7.6.tgz && \
    cd Python-3.7.6 && \
    ./configure --enable-optimizations --enable-shared  && \
    make install && \
    rm -rf /tmp/python && \
    apt-get -y purge wget zlib1g-dev libffi-dev && \
    apt-get -y autoremove && \
    apt-get -y clean && \
    rm -rf /var/lib/apt

COPY --from=mtasa /home/mtasa /home/mtasa

VOLUME /home/mtasa/mods/deathmatch
VOLUME /home/mtasa/x64/modules
USER mtasa
CMD ./mta-server64