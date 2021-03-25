FROM ubuntu:20.04

RUN set -x \
    && apt-get -qq update \
    && apt-get install -yq --no-install-recommends wget \
    && apt-get install -yq --no-install-recommends ca-certificates \
    && apt-get install -yq --no-install-recommends tar \
    && apt-get purge -y --auto-remove \
    && rm -rf /var/lib/apt/lists/*


RUN wget https://github.com/prometheus-community/pgbouncer_exporter/releases/download/v0.4.0/pgbouncer_exporter-0.4.0.linux-amd64.tar.gz
RUN tar -xf pgbouncer_exporter-0.4.0.linux-amd64.tar.gz
RUN ./pgbouncer_exporter-0.4.0.linux-amd64/pgbouncer_exporter -h

ENTRYPOINT ./pgbouncer_exporter-0.4.0.linux-amd64/pgbouncer_exporter --pgBouncer.connectionString="postgres://postgres:@127.0.0.1:5432/pgbouncer?sslmode=disable"
