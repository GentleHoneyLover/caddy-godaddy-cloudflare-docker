FROM caddy:builder AS builder

LABEL maintainer="gentlehoneylover"

RUN xcaddy build \
    --with github.com/caddy-dns/godaddy \
    --with github.com/caddy-dns/cloudflare@188b4850c0f2f5565a6310810c936ea960e2210f

FROM caddy:latest

COPY --from=builder /usr/bin/caddy /usr/bin/caddy
