[Docker](https://www.docker.com/) image with [healthcheck](https://docs.docker.com/engine/reference/builder/#healthcheck)
and with [H5BP](https://github.com/h5bp) configs.
Docker image under the terms of a [FreeBSD](https://raw.githubusercontent.com/p17-family/nginx/refs/heads/main/LICENSE) license
and H5BP configs under [MIT](https://raw.githubusercontent.com/p17-family/nginx/refs/heads/main/LICENSE_H5BP) license.

# Usage:
Dockerfile:
```dockerfile
FROM ghcr.io/p17-family/nginx:latest AS web
COPY yourconf.nginx.conf /etc/nginx/conf.d/default.conf
# your commands
```
### OR:
Dockerfile:
```dockerfile
FROM ghcr.io/p17-family/nginx:latest AS web
COPY yourconf.nginx.conf /opt/nginx-confs/default.conf.dist
# your commands
COPY yourdocker-command.sh /bin/docker-command.sh
RUN sed -i ':a;N;$!ba;s/\r//g' /bin/docker-command.sh \
    && chmod +x /bin/docker-command.sh
CMD ["/bin/docker-command.sh"]
```
yourdocker-command.sh:
```sh
#!/bin/sh
envsubst '${YOUR_ENV}' < /opt/nginx-confs/default.conf.dist > /etc/nginx/conf.d/default.conf
# your commands
nginx -g 'daemon off;'
```
