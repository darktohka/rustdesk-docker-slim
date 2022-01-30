FROM debian:unstable-slim AS builder

COPY create_appdir.sh /tmp/
COPY binaries /tmp/binaries

WORKDIR /tmp
RUN /bin/bash create_appdir.sh

FROM scratch

COPY --from=builder /tmp/app/ /

WORKDIR /srv
USER 3300
