# caddy-godaddy-cloudflare-docker
A Caddy Docker image with GoDaddy and Cloudflare DNS modules added. Built on the official Caddy image and following their documentation — see [Caddy image on Docker Hub](https://hub.docker.com/_/caddy) for details. The usage and configuration of the container is the same as the official Caddy one. 

You can review the Dockerfile [here](https://github.com/GentleHoneyLover/caddy-godaddy-cloudflare-docker/blob/master/Dockerfile). Please report all issues [here](https://github.com/GentleHoneyLover/caddy-godaddy-cloudflare-docker/issues).

<p align="center">
  <img width="600" src="https://raw.githubusercontent.com/docker-library/docs/7f3881a28c29ed29bb1a38681b95bd785a8a6da5/caddy/logo.png" alt="Caddy"><br><br>
</p>

## What is Caddy
[Caddy 2](https://caddyserver.com) is a powerful, enterprise-ready, open source web server with automatic HTTPS written in Go.

### Basic Usage
The default config file simply serves files from `/usr/share/caddy`, so if you want to serve `index.html` from the current working directory:

```sh
$ echo "hello world" > index.html
$ docker run -d -p 80:80 \
    -v $PWD/index.html:/usr/share/caddy/index.html \
    -v caddy_data:/data \
    docker.io/gentlehoneylover/caddy-godaddy-cloudflare:latest
...
$ curl http://localhost/
hello world
```


To override the default `Caddyfile`, you can mount a new one at `/etc/caddy/Caddyfile`:
```sh
$ docker run -d -p 80:80 \
    -v $PWD/Caddyfile:/etc/caddy/Caddyfile \
    -v caddy_data:/data \
    docker.io/gentlehoneylover/caddy-godaddy-cloudflare:latest
```

### Automatic TLS

The default `Caddyfile` only listens to port `80`, and does not set up automatic TLS. However, if you have a domain name for your site, and its A/AAAA DNS records are properly pointed to this machine's public IP, then you can use this command to simply serve a site over HTTPS:

```sh
$ docker run -d -p 80:80 -p 443:443 -p 443:443/udp \
    -v /site:/srv \
    -v caddy_data:/data \
    -v caddy_config:/config \
    docker.io/gentlehoneylover/caddy-godaddy-cloudflare:latest caddy file-server --domain example.com
```

The key here is that Caddy is able to listen to ports `80` and `443`, both required for the ACME HTTP challenge.

See [Caddy's docs](https://caddyserver.com/docs/automatic-https) for more information on automatic HTTPS support!

### Docker Compose example

If you prefer to use `docker-compose` to run your stack, here's a sample service definition.

```yaml
version: "3.7"

services:
  caddy:
    image: docker.io/gentlehoneylover/caddy-godaddy-cloudflare:latest
    restart: unless-stopped
    ports:
      - "80:80"
      - "443:443"
      - "443:443/udp"
    volumes:
      - $PWD/Caddyfile:/etc/caddy/Caddyfile
      - $PWD/site:/srv
      - caddy_data:/data
      - caddy_config:/config

volumes:
  caddy_data:
    external: true
  caddy_config:
```
