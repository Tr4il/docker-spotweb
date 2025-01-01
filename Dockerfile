FROM alpine:3.21
LABEL org.opencontainers.image.authors="Tr4il - forked from Erik de Vries <docker@erikdevries.nl>"
LABEL org.opencontainers.image.version="fc852d8826649b18c18ecd895874b8da4c3c5f2f"

# Disable timeout for starting services to make "wait for sql" work
ENV S6_CMD_WAIT_FOR_SERVICES_MAXTIME=0
ENV TZ=Europe/Amsterdam
# Default 5 minute interval configuration for Spotweb update cronjob
ENV CRON_INTERVAL="*/5 * * * *"

RUN apk -U update && \
    apk -U upgrade && \
    apk -U add --no-cache \
        bash \
        coreutils \
        ca-certificates \
        shadow \
        curl \
        git \
        nginx \
        tar \
        xz \
        tzdata \
        php84 \
        php84-fpm \
        php84-curl \
        php84-dom \
        php84-gettext \
        php84-xml \
        php84-simplexml \
        php84-zip \
        php84-zlib \
        php84-gd \
        php84-openssl \
        php84-mysqli \
        php84-pdo \
        php84-pdo_mysql \
        php84-pgsql \
        php84-pdo_pgsql \
        php84-sqlite3 \
        php84-pdo_sqlite \
        php84-json \
        php84-mbstring \
        php84-ctype \
        php84-opcache \
        php84-session \
        php84-intl \
        mysql-client \
        mariadb-connector-c \
        s6-overlay \
    && \
    git clone --depth=1 -b develop https://github.com/spotweb/spotweb.git /app

# Configure Spotweb
COPY ./conf/spotweb /app

# Copy root filesystem
COPY rootfs /

# create default user / group and folders
RUN groupadd -g 1000 abc && \
    useradd -u 1000 -g abc -d /app -s /bin/false abc

EXPOSE 80

ENTRYPOINT ["/init"]
