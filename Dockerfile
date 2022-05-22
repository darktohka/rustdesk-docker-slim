FROM debian:unstable-slim AS builder

COPY create_appdir.sh /tmp/

WORKDIR /tmp
RUN \
  apt-get update \
  && apt-get install -y curl unzip \
  && /bin/bash create_appdir.sh

FROM scratch

COPY --from=builder /tmp/app/ /

WORKDIR /srv
USER 3300
