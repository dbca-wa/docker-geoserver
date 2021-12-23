FROM kartoza/geoserver:2.17.2
LABEL org.opencontainers.image.source https://github.com/dbca-wa/docker-geoserver
LABEL maintainer "DBCA ASI <asi@dbca.wa.gov.au>"

COPY log4j-1.2.17.norce.jar /usr/local/tomcat/webapps/geoserver/WEB-INF/lib/log4j-1.2.17.jar
