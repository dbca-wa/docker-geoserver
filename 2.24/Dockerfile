# syntax=docker/dockerfile:1
# Geoserver 2.15+ is tested on Java 11, OpenJDK
# Reference: https://docs.geoserver.org/stable/en/user/production/java.html
ARG TOMCAT_VERSION="9-jre11"
FROM docker.io/tomcat:$TOMCAT_VERSION
LABEL maintainer "Ashley Felton <ashley.felton@dbca.wa.gov.au>"
LABEL org.opencontainers.image.source https://github.com/dbca-wa/docker-geoserver
LABEL org.opencontainers.image.description="GeoServer"

ARG GEOSERVER_VERSION="2.24.3"
ARG GEOSERVER_DATA_DIR="/data/geoserver"
ARG GEOSERVER_PLUGINS="css geopkg-output printing pyramid vectortiles wps"
ARG GEOSERVER_FONTS="lato notosans opensans poppins roboto ubuntu"

ENV GEOSERVER_FONTS=${GEOSERVER_FONTS} \
    GEOSERVER_VERSION=${GEOSERVER_VERSION} \
    GEOSERVER_DATA_DIR=${GEOSERVER_DATA_DIR} \
    GEOSERVER_PLUGINS=${GEOSERVER_PLUGINS} \
    GEOSERVER_NODE_OPTS='id:$host_name' \
    GEOWEBCACHE_CACHE_DIR='/data/gwc' \
    UMASK=002

# Ref: https://docs.geoserver.org/stable/en/user/production/container.html
ENV CATALINA_OPTS="-Xms256m -Xmx2g \
    -Djava.awt.headless=true -server \
    -Dfile.encoding=UTF-8 \
    -Djavax.servlet.request.encoding=UTF-8 \
    -Djavax.servlet.response.encoding=UTF-8 \
    -D-XX:SoftRefLRUPolicyMSPerMB=36000 \
    -Xbootclasspath/a:$CATALINA_HOME/lib/marlin.jar \
    -Dsun.java2d.renderer=sun.java2d.marlin.DMarlinRenderingEngine \
    -Dorg.geotools.coverage.jaiext.enabled=true"

# persistent / runtime deps
RUN apt-get update && apt-get install -y --no-install-recommends libnetcdf-c++4 curl unzip fnt xz-utils binutils && rm -r /var/lib/apt/lists/*

# Install Google Fonts
RUN \
    fnt update  && \
    for FONT in $GEOSERVER_FONTS; \
    do \
        fnt install "${FONT}" ; \
    done && \
    fnt list

# Install GeoServer
RUN <<EOT bash
    curl -sS -L -O https://sourceforge.net/projects/geoserver/files/GeoServer/$GEOSERVER_VERSION/geoserver-$GEOSERVER_VERSION-war.zip
    unzip -d $CATALINA_HOME/webapps/ geoserver-$GEOSERVER_VERSION-war.zip geoserver.war
    unzip -d $CATALINA_HOME/webapps/geoserver $CATALINA_HOME/webapps/geoserver.war
    rm geoserver-$GEOSERVER_VERSION-war.zip $CATALINA_HOME/webapps/geoserver.war
    mv $CATALINA_HOME/webapps/geoserver/WEB-INF/lib/marlin-*.jar $CATALINA_HOME/lib/marlin.jar
    rm -rf $CATALINA_HOME/webapps/geoserver/data/workspaces/{tiger,nurc,sf,topp,cite,sde}
    rm -rf $CATALINA_HOME/webapps/geoserver/data/data/{nyc,sf,shapefiles,taz_shapes}
    rm -rf $CATALINA_HOME/webapps/geoserver/data/{layergroups,coverages}/*
    rm -rf $CATALINA_HOME/webapps/geoserver/data/styles/tiger_*
    mkdir -p $GEOSERVER_DATA_DIR $GEOWEBCACHE_CACHE_DIR
    mv $CATALINA_HOME/webapps/geoserver/data/* $GEOSERVER_DATA_DIR
    sed -e 's/>PARTIAL-BUFFER2</>SPEED</g' -i $CATALINA_HOME/webapps/geoserver/WEB-INF/web.xml
    chgrp -R 0 $CATALINA_HOME $GEOWEBCACHE_CACHE_DIR $GEOSERVER_DATA_DIR
    chmod -R g=u $CATALINA_HOME $GEOWEBCACHE_CACHE_DIR $GEOSERVER_DATA_DIR
EOT

# Install GeoServer Plugins
RUN for PLUGIN in ${GEOSERVER_PLUGINS}; \
    do \
      curl --retry 5 --retry-all-errors -sS -L -O https://sourceforge.net/projects/geoserver/files/GeoServer/$GEOSERVER_VERSION/extensions/geoserver-$GEOSERVER_VERSION-$PLUGIN-plugin.zip && \
      unzip -o geoserver-$GEOSERVER_VERSION-$PLUGIN-plugin.zip -d $CATALINA_HOME/webapps/geoserver/WEB-INF/lib/ && \
      rm geoserver-$GEOSERVER_VERSION-$PLUGIN-plugin.zip ; \
    done

# Expose GeoServer's default port
EXPOSE 8080

# Enable CORS
RUN sed -i '\:</web-app>:i \
    <filter>\n \
        <filter-name>CorsFilter</filter-name>\n \
        <filter-class>org.apache.catalina.filters.CorsFilter</filter-class>\n \
        <init-param>\n \
            <param-name>cors.allowed.origins</param-name>\n \
            <param-value>*</param-value>\n \
        </init-param>\n \
    </filter>\n \
    <filter-mapping>\n \
        <filter-name>CorsFilter</filter-name>\n \
        <url-pattern>/*</url-pattern>\n \
    </filter-mapping>' $CATALINA_HOME/conf/web.xml

RUN chmod -R g=u /etc/passwd /var/log

COPY <<-EOT $CATALINA_HOME/webapps/ROOT/index.jsp
<%
  final String redirectURL = "/geoserver/web/";
  response.setStatus(HttpServletResponse.SC_MOVED_PERMANENTLY);
  response.setHeader("Location", redirectURL);
%>
EOT

COPY docker-entrypoint.sh first-run-config.sh /

# Create a non-root user.
ARG UID=10001
RUN useradd --no-create-home --no-log-init --uid "${UID}"  --gid 0 geoserver

USER ${UID}
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["geoserver"]
