FROM oscarfonts/geoserver:2.18.1
LABEL org.opencontainers.image.source https://github.com/dbca-wa/docker-geoserver
LABEL maintainer "DBCA ASI <asi@dbca.wa.gov.au>"

ARG PLUGIN_URL="https://sourceforge.net/projects/geoserver/files/GeoServer/${GEOSERVER_VERSION}/extensions"
ARG EXTENSIONS="vectortiles css"

RUN pushd /var/local/geoserver-exts; \
    for EXT in ${EXTENSIONS}; do \
        fname="geoserver-${GEOSERVER_VERSION}-${EXT}-plugin.zip" \
        wget ${PLUGIN_URL}/${fname} \
        unzip -d ${ext} ${fname}; rm ${fname} \
    done; popd
RUN mv /var/local/geoserver-exts/*/*.jar /usr/local/geoserver/WEB-INF/lib