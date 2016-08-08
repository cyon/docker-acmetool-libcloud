FROM cyon/acmetool:0.0.56-0

MAINTAINER Dominic Luechinger 'dol@cyon.ch'

ENV NAMESERVER_LIST_PATH /var/lib/acme/cache

RUN apk add --no-cache \
        ca-certificates \
        su-exec \
    && su-exec acmetool true

COPY requirements.txt /requirements.txt

RUN set -ex && \
  pip3 install --no-cache-dir --ignore-installed -r requirements.txt && \
  find /usr/local -depth \
    \( \
        \( -type d -a -name test -o -name tests \) \
        -o \
        \( -type f -a -name '*.pyc' -o -name '*.pyo' \) \
    \) -exec rm -rf '{}' + && \
  rm -rf /usr/src/python ~/.cache

COPY bin/acmetool_update_dns /usr/bin
COPY hooks/dns_challenge /usr/lib/acme/hooks/
COPY hooks/live-update /usr/lib/acme/hooks/live-update

RUN chmod +x /usr/lib/acme/hooks/dns_challenge

# Start with the batch mode
CMD ["--", "--batch"]
