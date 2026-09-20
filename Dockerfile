FROM ubuntu:26.04 AS builder

ARG NETHACK_URL=https://nethack.org/download/5.0.0/nethack-500-src.tgz
ARG JNETHACK_URL=https://github.com/jnethack/jnethack-release/releases/download/v5.0.0-0.1/jnethack-5.0.0-0.1.diff.gz
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      bison ca-certificates curl flex gcc libc6-dev libncurses-dev make \
      patch uuid-dev \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /tmp/jnethack
RUN curl -fSL ${NETHACK_URL} | tar xzf - --strip-components=1 \
 && curl -fSL ${JNETHACK_URL} | gzip -dc | patch -p1

# 5.0.0-0.1 only wires japanese/ into the Windows nmake build
COPY patches/jnethack-5.0.0-0.1-unix.patch /tmp/
RUN patch -p1 < /tmp/jnethack-5.0.0-0.1-unix.patch

RUN (cd sys/unix && sh setup.sh hints/linux.500) \
 && make fetch-lua \
 && make all     PREFIX=/usr/local \
 && make install PREFIX=/usr/local


FROM ubuntu:26.04
LABEL maintainer="TAKANO Mitsuhiro <takano32@gmail.com>"

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
 && apt-get install -y --no-install-recommends libncursesw6 libuuid1 \
 && rm -rf /var/lib/apt/lists/*

COPY --from=builder /usr/local/games /usr/local/games
COPY docker-entrypoint.sh /usr/local/bin/

# The playground is kept empty and seeded from the pristine copy at startup,
# so that a volume mounted over it survives an image update.
RUN mv /usr/local/games/lib/nethackdir /usr/local/share/nethackdir \
 && docker-entrypoint.sh /usr/local/games/nethack --version \
 && rm -rf /usr/local/games/lib/nethackdir \
 && mkdir /usr/local/games/lib/nethackdir

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["/usr/local/games/nethack"]
