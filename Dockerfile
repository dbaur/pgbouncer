FROM ubuntu:20.04

RUN set -x \
    && apt-get -qq update \
    && apt-get install -yq --no-install-recommends pgbouncer=1.12.0-3 \
    && apt-get install -yq --no-install-recommends wget \
    && apt-get install -yq --no-install-recommends ca-certificates \
    && apt-get purge -y --auto-remove \
    && rm -rf /var/lib/apt/lists/*

RUN wget https://www.digicert.com/CACerts/BaltimoreCyberTrustRoot.crt
RUN openssl x509 -inform DER -in BaltimoreCyberTrustRoot.crt -text -out /etc/root.crt

RUN mkdir -p /var/log/postgresql
RUN chmod -R 755 /var/log/postgresql
RUN chown -R postgres:postgres /var/log/postgresql


ENV PG_CONFIG /etc/pgbouncer/pgbouncer.ini
ENV PG_USER postgres

USER postgres
ENTRYPOINT pgbouncer -u $PG_USER $PG_CONFIG
