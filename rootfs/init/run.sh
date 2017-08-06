#!/bin/sh

set -e

HOSTNAME=$(hostname -s)

WORK_DIR=/srv/elasticsearch

DATA_DIR=${WORK_DIR}/data
CLUSTER_NAME=${CLUSTER_NAME:-"DivineOrder"}

# ---------------------------------------------------------

CONFIG="/opt/elasticsearch/config/elasticsearch.yml"

create_config() {

  cat << EOF > ${CONFIG}

path:
  data: ${DATA_DIR}
  logs: /var/log/elasticsearch

cluster.name: ${CLUSTER_NAME}

node:
  name: elastic-1
  master: true

#bootstrap.memory_lock: true
#bootstrap.mlockall: true

network:
  bind_host: 0.0.0.0
  host: 0.0.0.0

transport.tcp.port: 9300-9400
http.port: 9200-9300

EOF
}

switch_to_sh() {
  sed -i \
    -e "s|^#!/bin/bash|#!/bin/sh|g" \
    /opt/elasticsearch/bin/elasticsearch
}

prepare() {
  mkdir -p ${DATA_DIR}
  chown elastic: ${DATA_DIR}
  chmod ug+rwx ${DATA_DIR}

  mkdir -p /var/log/elasticsearch
  chown elastic: /var/log/elasticsearch
  chmod ug+rwx /var/log/elasticsearch
}

run() {

  prepare
  create_config
  switch_to_sh

  if ( [ -n "${MAX_MAP_COUNT}" ] && [ -f /proc/sys/vm/max_map_count ] )
  then
    sysctl -q -w vm.max_map_count=${MAX_MAP_COUNT}
  fi

  su --command /opt/elasticsearch/bin/elasticsearch elastic
}

run

# EOF
