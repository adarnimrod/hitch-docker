ARG Version="1.5.0"
ARG AlpineVersion="3.10"

FROM alpine:$AlpineVersion as builder
# hadolint ignore=DL3018
RUN apk add --update --no-cache \
    autoconf \
    automake \
    bison \
    build-base \
    flex \
    libev-dev \
    openssl-dev
ARG Version
ENV VERSION="$Version"
RUN wget "https://github.com/varnish/hitch/archive/${VERSION}.tar.gz" && \
    tar -vxz --no-same-owner --no-same-permissions -f "${VERSION}.tar.gz"
WORKDIR /hitch-${Version}
ENV LDFLAGS="--static"
RUN ./bootstrap && \
    ./configure && \
    make && \
    make install

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
