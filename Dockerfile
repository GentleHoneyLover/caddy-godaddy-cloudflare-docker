FROM caddy:builder AS builder

LABEL maintainer="gentlehoneylover"
ENV BUILD_DATE="2-Nov-2023"

RUN xcaddy build \
    --with github.com/caddy-dns/godaddy \
    --with github.com/caddy-dns/cloudflare

FROM caddy:latest

COPY --from=builder /usr/bin/caddy /usr/bin/caddy
