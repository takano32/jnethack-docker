FROM ubuntu:23.10
LABEL maintainer "TAKANO Mitsuhiro <takano32@gmail.com>"

ENV NETHACK_URL=https://github.com/takano32/jnethack-docker/files/12524492/nethack-367-src.tgz
ENV JNETHACK_URL=https://github.com/takano32/jnethack-docker/files/12524493/jnethack-3.6.7-0.1.diff.gz
ENV NETHACK_DIR=NetHack-3.6.7

ENV DEBIAN_FRONTEND=noninteractive
ENV DEBCONF_NOWARNINGS=yes

RUN apt-get update && apt-get upgrade -y
RUN apt-get dist-upgrade -y && apt-get autoremove -y
RUN apt-get install -y gcc bison flex
RUN apt-get install -y curl patch make
RUN apt-get install -y libncurses-dev
RUN apt-get install -y nkf groff bsdextrautils

RUN mkdir -p /opt/jnethack
RUN cd /opt && curl -SL ${NETHACK_URL} | tar xzf -
RUN cd /opt/${NETHACK_DIR} && curl -SL ${JNETHACK_URL} | gzip -dc | patch -p1
RUN cd /opt/${NETHACK_DIR} && sh configure
RUN cd /opt/${NETHACK_DIR} && make all     PREFIX=/usr/local
RUN cd /opt/${NETHACK_DIR} && make install PREFIX=/usr/local

ENTRYPOINT ["/usr/local/games/jnethack"]

