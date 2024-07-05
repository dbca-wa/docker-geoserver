FROM kartoza/geoserver:2.25.0 as builder_base
MAINTAINER asi@dbca.wa.gov.au
LABEL org.opencontainers.image.source https://github.com/dbca-wa/docker-geoserver

ENV \
    GEOSERVER_UID=1000 \
    GEOSERVER_GID=1000 \
    USER=geoserver \
    GROUP_NAME=geoserver \
    GEOSERVER_HOME=/geoserver \
    GEOSERVER_DATA_DIR=/geoserver/data \
    GEOWEBCACHE_CACHE_DIR=/geoserver/data/gwc \
    COMMUNITY_PLUGINS_DIR=/geoserver/community_plugins  \
    EXTRA_CONFIG_DIR=/geoserver/extra_settings \
    STABLE_PLUGINS_DIR=/geoserver/stable_plugins \
    RUN_AS_ROOT=true \
    LOG_MAX_FILE_SIZE=5MB \
    LOG_MAX_BACKUP_INDEX=20

run  groupadd -r geoserver -g 1000
run  useradd -l -m -d /home/geoserver -u 1000 --gid 1000 -s /bin/bash -G geoserver geoserver

run mkdir -p /etc/certs && chown geoserver:geoserver /etc/certs && chmod 700 /etc/certs

run mkdir -p /opt/footprints_dir && chown -R geoserver:geoserver /opt/footprints_dir && chmod -R 750 /opt/footprints_dir

run mkdir -p /docker-entrypoint-geoserver.d && chown -R geoserver:geoserver /docker-entrypoint-geoserver.d && chmod -R 750 /docker-entrypoint-geoserver.d

run mkdir -p /usr/local/tomcat && chown -R geoserver:geoserver /usr/local/tomcat && chmod -R 755 /usr/local/tomcat 

run mkdir -p  /geoserver/stable_plugins && mkdir -p  /geoserver/community_plugins && mkdir -p  /geoserver/extra_settings && mkdir -p  /geoserver/data/gwc  && chown -R geoserver:geoserver /geoserver && chmod -R 755 /geoserver

run mkdir -p /usr/share/fonts && chown -R geoserver:geoserver /usr/share/fonts && chmod -R 755 /usr/share/fonts

run chown geoserver:geoserver /tomcat_apps.zip && chmod -R 755 /tomcat_apps.zip
run chown geoserver:geoserver /tmp && chmod -R 777 /tmp
run chown -R geoserver:geoserver /opt/fonts && chmod -R 775 /opt/fonts
run chown -R geoserver:geoserver /scripts && chmod -R 775 /scripts
run chown -R geoserver:geoserver /build_data && chmod -R 775 /build_data

COPY log4j.properties /build_data/log4j.properties


USER geoserver
EXPOSE 8080
