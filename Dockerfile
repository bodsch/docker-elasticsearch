
FROM bodsch/docker-openjdk-8:1612-01

MAINTAINER Bodo Schulz <bodo@boone-schulz.de>

LABEL version="0.0.2"

ENV \
  ES_VERSION=5.1.1

EXPOSE 9200 9300

# ---------------------------------------------------------------------------------------------------------------------

RUN \
  apk --no-cache update && \
  apk --no-cache upgrade && \
  apk --no-cache add \
    curl && \
  curl \
  --silent \
  --location \
  --retry 3 \
  --cacert /etc/ssl/certs/ca-certificates.crt \
    https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-${ES_VERSION}.tar.gz \
    | gunzip \
    | tar x -C /opt/ && \
  ln -s /opt/elasticsearch-${ES_VERSION} /opt/elasticsearch && \
  rm -v /opt/elasticsearch/bin/*.exe && \
  rm -v /opt/elasticsearch/bin/*.bat && \
  mv /opt/elasticsearch/config/elasticsearch.yml /opt/elasticsearch/config/elasticsearch.yml-DIST

#WORKDIR /opt/elasticsearch

COPY rootfs/opt/elasticsearch/config/elasticsearch.yaml /opt/elasticsearch/config/elasticsearch.yml

# CMD /opt/startup.sh

CMD /bin/bash

# ---------------------------------------------------------------------------------------------------------------------
