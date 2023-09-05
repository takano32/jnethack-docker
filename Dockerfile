FROM ubuntu:23.10
LABEL maintainer "TAKANO Mitsuhiro <takano32@gmail.com>"

ENV NETHACK_URL=https://github.com/takano32/jnethack-docker/files/12524492/nethack-367-src.tgz
ENV JNETHACK_URL=https://github.com/takano32/jnethack-docker/files/12524493/jnethack-3.6.7-0.1.diff.gz

ENV DEBIAN_FRONTEND=noninteractive
ENV DEBCONF_NOWARNINGS=yes

RUN apt-get update && apt-get upgrade -y
RUN apt-get dist-upgrade -y && apt-get autoremove -y
RUN apt-get install -y gcc bison flex
RUN apt-get install -y curl
#RUN apt-get install -y build-essential bison flex
RUN apt-get install -y patch
RUN apt-get install -y make
RUN apt-get install -y nkf
RUN apt-get install -y libncurses-dev
#RUN apt-get install -y libstdc++
#RUN apt-get install -y libconfig-dev

RUN mkdir -p /opt/jnethack
RUN cd /opt && curl -SL ${NETHACK_URL} | tar xzf -
RUN cd /opt/NetHack-3.6.7 && curl -SL ${JNETHACK_URL} | gzip -dc | patch -p1
RUN cd /opt/NetHack-3.6.7 && sh configure
#RUN cd /opt/NetHack-3.6.7 && sh sys/unix/setup.sh
#RUN cd /opt/NetHack-3.6.7 && find . -type f -regex '.*\.[ch]$' | xargs -n 32 nkf -w --overwrite

#RUN cd /opt/NetHack-3.6.7 && make all

