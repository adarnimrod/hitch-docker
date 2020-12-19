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
    ;
ARG Version
ENV VERSION="$Version"
RUN wget "https://github.com/varnish/hitch/archive/${VERSION}.tar.gz" && \
    tar --no-same-owner --no-same-permissions -xzf "${VERSION}.tar.gz"
ENV LDFLAGS="--static"
WORKDIR /hitch-$Version
RUN ./bootstrap --disable-documentation && \
    make ENABLE_DOCUMENTATION=0 && \
    make install && \
    make check

FROM alpine:$AlpineVersion
# hadolint ignore=DL3018
RUN apk add --update --no-cache ca-certificates tini netcat-openbsd openssl
COPY --from=builder /usr/local/sbin/hitch /usr/local/sbin/
ARG Version
ENV VERSION="$Version"
RUN [ "$(hitch --version)" = "hitch $VERSION" ]
ENTRYPOINT ["tini", "--", "hitch"]
HEALTHCHECK CMD pgrep hitch || exit 1
LABEL Name="Hitch"
LABEL Version="${Version}"
