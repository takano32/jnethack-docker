FROM ubuntu:26.04 AS builder

ARG NETHACK_URL=https://github.com/user-attachments/files/12524492/nethack-367-src.tgz
ARG JNETHACK_URL=https://github.com/user-attachments/files/32049840/jnethack-3.6.7-0.2.diff.gz
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      bison bsdextrautils ca-certificates curl flex gcc groff libc6-dev \
      libncurses-dev make nkf patch \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /tmp/jnethack
RUN curl -fSL ${NETHACK_URL} | tar xzf - --strip-components=1 \
 && curl -fSL ${JNETHACK_URL} | gzip -dc | patch -p1

# GCC 15+ defaults to C23, which conflicts with NetHack 3.6.7's old-style declarations
RUN sh configure \
 && make all     CC="cc -std=gnu17" PREFIX=/usr/local \
 && make install CC="cc -std=gnu17" PREFIX=/usr/local


FROM ubuntu:26.04
LABEL maintainer="TAKANO Mitsuhiro <takano32@gmail.com>"

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
 && apt-get install -y --no-install-recommends libncurses6 \
 && rm -rf /var/lib/apt/lists/*

COPY --from=builder /usr/local/games /usr/local/games
RUN /usr/local/games/jnethack --version

ENTRYPOINT ["/usr/local/games/jnethack"]
