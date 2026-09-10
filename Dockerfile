FROM ubuntu:26.04
LABEL maintainer="TAKANO Mitsuhiro <takano32@gmail.com>"

ENV NETHACK_URL=https://github.com/user-attachments/files/12524492/nethack-367-src.tgz
ENV JNETHACK_URL=https://github.com/user-attachments/files/32049840/jnethack-3.6.7-0.2.diff.gz

ENV DEBIAN_FRONTEND=noninteractive
ENV DEBCONF_NOWARNINGS=yes

RUN apt-get update && apt-get upgrade -y
RUN apt-get dist-upgrade -y && apt-get autoremove -y
RUN apt-get install -y gcc bison flex
RUN apt-get install -y curl patch make
RUN apt-get install -y libncurses-dev
RUN apt-get install -y nkf groff bsdextrautils

ENV BUILD_DIR=/tmp/jnethack
RUN mkdir -p ${BUILD_DIR}
RUN cd ${BUILD_DIR} && curl -SL ${NETHACK_URL} | tar xzf - --strip-components=1
RUN cd ${BUILD_DIR} && curl -SL ${JNETHACK_URL} | gzip -dc | patch -p1
RUN cd ${BUILD_DIR} && sh configure
RUN cd ${BUILD_DIR} && make all     CC="cc -std=gnu17" PREFIX=/usr/local
RUN cd ${BUILD_DIR} && make install CC="cc -std=gnu17" PREFIX=/usr/local
RUN rm -rf ${BUILD_DIR}

ENTRYPOINT ["/usr/local/games/jnethack"]

