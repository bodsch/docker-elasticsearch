
FROM alpine:3.6

MAINTAINER Bodo Schulz <bodo@boone-schulz.de>

ENV \
  ALPINE_MIRROR="mirror1.hs-esslingen.de/pub/Mirrors" \
  ALPINE_VERSION="v3.6" \
  TERM=xterm \
  BUILD_DATE="2017-07-08" \
  APACHE_MIRROR=mirror.synyx.de \
  TOMCAT_VERSION=8.5.16 \
  CATALINA_HOME=/opt/tomcat \
  OPENJDK_VERSION="8.131.11-r2" \
  ES_VERSION="5.5.0" \
  JAVA_HOME=/usr/lib/jvm/default-jvm \
  PATH=${PATH}:/opt/jdk/bin:${CATALINA_HOME}/bin \
  LANG=C.UTF-8

LABEL version="0.0.0"

EXPOSE 9200 9300

# ---------------------------------------------------------------------------------------------------------------------

RUN \
  echo "http://${ALPINE_MIRROR}/alpine/${ALPINE_VERSION}/main"       > /etc/apk/repositories && \
  echo "http://${ALPINE_MIRROR}/alpine/${ALPINE_VERSION}/community" >> /etc/apk/repositories && \
  apk --no-cache update && \
  apk --no-cache upgrade && \
  apk --no-cache add \
    curl \
    openjdk8-jre-base \
    shadow && \
  echo "export LANG=${LANG}" > /etc/profile.d/locale.sh && \
  echo 'hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4' >> /etc/nsswitch.conf && \
  sed -i 's,#networkaddress.cache.ttl=-1,networkaddress.cache.ttl=30,' ${JAVA_HOME}/jre/lib/security/java.security && \
  mkdir /opt && \
  useradd -d /opt/elasticsearch --no-create-home --shell /bin/sh elastic || true && \
  curl \
    --silent \
    --location \
    --retry 3 \
    --cacert /etc/ssl/certs/ca-certificates.crt \
      https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-${ES_VERSION}.tar.gz \
      | gunzip \
      | tar x -C /opt/ && \
  chown -R elastic: /opt/elasticsearch-${ES_VERSION} && \
  ln -s /opt/elasticsearch-${ES_VERSION} /opt/elasticsearch && \
  rm -v /opt/elasticsearch/bin/*.exe && \
  rm -v /opt/elasticsearch/bin/*.bat && \
  mv /opt/elasticsearch/config/elasticsearch.yml /opt/elasticsearch/config/elasticsearch.yml-DIST

COPY rootfs/ /

WORKDIR "/opt/elasticsearch"

CMD ["/init/run.sh"]

# ---------------------------------------------------------------------------------------------------------------------
