# docker-geoserver

DBCA focused build of geoserver with opinionated default extensions

Based on [kartoza/docker-geoserver](https://github.com/kartoza/docker-geoserver)
and [meteofi/docker-geoserver](https://github.com/meteofi/docker-geoserver).

## Running

Run as a service, exposing port 8080 and using a hosted GEOSERVER_DATA_DIR:

```bash
docker run -d -p 8080:8080 -v ${PWD}/data_dir:/var/local/geoserver ghcr.io/dbca-wa/geoserver
```
