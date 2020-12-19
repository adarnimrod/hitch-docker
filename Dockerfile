ARG Version="1.7.0"
ARG AlpineVersion="3.12"

FROM alpine:$AlpineVersion as builder
# hadolint ignore=DL3018
RUN apk add --update --no-cache \
    autoconf \
    automake \
    bison \
    build-base \
    flex \
    libev-dev \
    openssl-dev \
    py3-docutils \
    ;
ARG Version
ENV VERSION="$Version"
# hadolint ignore=DL3020
ADD "https://hitch-tls.org/source/hitch-${VERSION}.tar.gz" /
RUN tar -xzf "${VERSION}.tar.gz"
WORKDIR /hitch-$Version
RUN ./bootstrap && \
    make && \
    make install && \
    make check

FROM alpine:$AlpineVersion
# hadolint ignore=DL3018
RUN apk add --update --no-cache \
        ca-certificates \
        libev \
        netcat-openbsd \
        openssl \
        tini \
        ;
COPY --from=builder /usr/local/sbin/hitch /usr/local/sbin/
ARG Version
ENV VERSION="$Version"
RUN [ "$(hitch --version)" = "hitch $VERSION" ]
ENTRYPOINT ["tini", "--", "hitch"]
HEALTHCHECK CMD pgrep hitch || exit 1
LABEL Name="Hitch"
LABEL Version="${Version}"
