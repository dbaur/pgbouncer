FROM ubuntu:20.04

RUN set -x \
    && apt-get -qq update \
    && apt-get install -yq --no-install-recommends pgbouncer=1.12.0-3 \
    && apt-get install -yq --no-install-recommends wget \
    && apt-get install -yq --no-install-recommends ca-certificates \
    && apt-get purge -y --auto-remove \
    && rm -rf /var/lib/apt/lists/*

RUN wget https://www.digicert.com/CACerts/BaltimoreCyberTrustRoot.crt.pem
RUN wget https://cacerts.digicert.com/DigiCertGlobalRootG2.crt.pem

COPY MicrosoftECCRootCertificateAuthority2017.crt /
COPY MicrosoftRSARootCertificateAuthority2017.crt /

RUN wget https://cacerts.digicert.com/DigiCertGlobalRootG3.crt.pem

RUN openssl x509 -inform DER -in MicrosoftECCRootCertificateAuthority2017.crt -outform PEM -out MicrosoftECCRootCertificateAuthority2017.crt
RUN openssl x509 -inform DER -in MicrosoftRSARootCertificateAuthority2017.crt -outform PEM -out MicrosoftRSARootCertificateAuthority2017.crt

RUN mv BaltimoreCyberTrustRoot.crt.pem BaltimoreCyberTrustRoot.crt
RUN mv DigiCertGlobalRootG2.crt.pem DigiCertGlobalRootG2.crt
RUN mv DigiCertGlobalRootG3.crt.pem DigiCertGlobalRootG3.crt

RUN cat *.crt >> /etc/root.crt

RUN mkdir -p /var/log/postgresql
RUN chmod -R 755 /var/log/postgresql
RUN chown -R postgres:postgres /var/log/postgresql


ENV PG_CONFIG /etc/pgbouncer/pgbouncer.ini
ENV PG_USER postgres

USER postgres
ENTRYPOINT pgbouncer -u $PG_USER $PG_CONFIG
