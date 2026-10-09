# Upstream's Dockerfile (XBEN-003-24/app/Dockerfile) with these changes:
# - the sources are copied from app/app/ (the vendored benchmark folder sits in app/)
# - the build argument FLAG defaults to this lab's fixed flag, the value upstream's Makefile passes
#   (FLAG{sha256 of "XBEN-003-24"}), since the spec passes no build arguments
# - on a Debian buster or bullseye base, apt reads archive.debian.org: both releases have left (or
#   are leaving) the Debian mirrors, so upstream's apt-get install fails there
FROM debian:bullseye-slim
RUN . /etc/os-release && case "$VERSION_CODENAME" in \
      buster) sec=buster/updates ;; bullseye) sec=bullseye-security ;; *) sec= ;; esac \
 && if [ -n "$sec" ]; then \
      printf 'deb http://archive.debian.org/debian %s main\ndeb http://archive.debian.org/debian-security %s main\n' \
        "$VERSION_CODENAME" "$sec" > /etc/apt/sources.list && rm -f /etc/apt/sources.list.d/*; fi

RUN apt-get update && apt-get install -y apache2 \
    libapache2-mod-wsgi-py3 \
    python3 \
    python3-pip \
    curl \
    && apt-get clean \
    && apt-get autoremove \
    && rm -rf /var/lib/apt/lists/*

COPY app/app/website/requirements.txt /var/www/idor_custom_authn_header_trading_platform/app/requirements.txt
RUN pip install -r /var/www/idor_custom_authn_header_trading_platform/app/requirements.txt

COPY app/app/idor_custom_authn_header_trading_platform-httpd.conf /etc/apache2/sites-available/idor_custom_authn_header_trading_platform-httpd.conf
COPY app/app/website/idor_custom_authn_header_trading_platform.wsgi /var/www/idor_custom_authn_header_trading_platform/
COPY app/app/website/run.py /var/www/idor_custom_authn_header_trading_platform/
COPY app/app/website/app /var/www/idor_custom_authn_header_trading_platform/app

ARG FLAG=FLAG{39c35247bd1ebb5196f6e49b51300fd895e4ce83559a7db6b89cc8b76b31c59f}
RUN echo -n $FLAG > /flag

RUN a2dissite 000-default.conf
RUN a2ensite idor_custom_authn_header_trading_platform-httpd.conf
RUN a2enmod headers

CMD  /usr/sbin/apache2ctl -D FOREGROUND
