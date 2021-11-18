FROM kartoza/geoserver:2.20.0
LABEL org.opencontainers.image.source https://github.com/dbca-wa/docker-geoserver
LABEL maintainer "DBCA ASI <asi@dbca.wa.gov.au>"

ARG STABLE_EXTENSIONS="authkey-plugin sldservice-plugin wps-plugin querylayer-plugin mbstyle-plugin css-plugin"
COPY serve-geopackages.py /usr/local/bin/serve-geopackages