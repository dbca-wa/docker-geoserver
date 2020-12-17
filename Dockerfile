FROM oscarfonts/geoserver:2.18.1
LABEL org.opencontainers.image.source https://github.com/dbca-wa/docker-geoserver
LABEL maintainer "DBCA ASI <asi@dbca.wa.gov.au>"

ARG PLUGIN_URL="https://sourceforge.net/projects/geoserver/files/GeoServer/${GEOSERVER_VERSION}/extensions"
ARG EXTENSIONS="authkey vectortiles sldservice wps querylayer mbstyle css"

RUN cd /var/local/geoserver-exts; for EXT in ${EXTENSIONS}; do \
        FNAME="geoserver-${GEOSERVER_VERSION}-${EXT}-plugin.zip"; \
        wget --max-redirect=40 ${PLUGIN_URL}/${FNAME}; \
        unzip -d ${EXT} ${FNAME}; rm ${FNAME}; \
    done; mv */*.jar /usr/local/geoserver/WEB-INF/lib
