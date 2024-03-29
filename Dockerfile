FROM kartoza/geoserver:2.20.1
LABEL org.opencontainers.image.source https://github.com/dbca-wa/docker-geoserver
LABEL maintainer "DBCA ASI <asi@dbca.wa.gov.au>"

ENV STABLE_EXTENSIONS="authkey-plugin sldservice-plugin wps-plugin querylayer-plugin mbstyle-plugin css-plugin mongodb-plugin"
COPY serve-geopackages.py /usr/local/bin/serve-geopackages
