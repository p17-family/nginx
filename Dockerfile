ARG NGINX_VERSION_ARG="stable"

FROM alpine/git:latest AS git
COPY ./docker/nginx/checkout-tag.sh /bin/checkout-tag.sh
RUN mkdir -p /opt/h5bp
WORKDIR /opt/h5bp
RUN git clone https://github.com/h5bp/server-configs-nginx.git /opt/h5bp/nginx
ARG H5BP_VERSION_ARG="latest"
RUN sed -i ':a;N;$!ba;s/\r//g' /bin/checkout-tag.sh \
    && chmod +x /bin/checkout-tag.sh \
    && /bin/checkout-tag.sh

FROM nginx:${NGINX_VERSION_ARG}-alpine AS web
LABEL maintainer="Nikolai Morozov <nikolai@p17.dev>"
RUN apk add --no-cache tzdata~=2025
ENV TZ=Europe/Moscow
COPY ./docker/nginx/config/nginx.conf /etc/nginx/nginx.conf
COPY ./docker/nginx/config/healthcheck.nginx.conf /etc/nginx/conf.d/healthcheck.conf
RUN mkdir -p /data/nginx/cache
COPY --from=git /opt/h5bp/nginx/mime.types /etc/nginx/
COPY --from=git /opt/h5bp/nginx/h5bp/media_types/character_encodings.conf /etc/nginx/h5bp/media_types/
COPY --from=git /opt/h5bp/nginx/h5bp/media_types/media_types.conf /etc/nginx/h5bp/media_types/
COPY --from=git /opt/h5bp/nginx/h5bp/web_performance/compression.conf /etc/nginx/h5bp/web_performance/
COPY --from=git /opt/h5bp/nginx/h5bp/web_performance/cache_expiration.conf /etc/nginx/h5bp/web_performance/
RUN nginx -t
VOLUME ["/var/log/nginx"]
VOLUME ["/data/nginx/cache"]
HEALTHCHECK CMD wget --quiet --tries=1 --spider http://127.0.0.1/self-health || exit 1
