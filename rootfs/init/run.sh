#!/bin/sh

HOSTNAME=$(hostname -s)

WORK_DIR=/srv/elasticsearch

DATA_DIR=${WORK_DIR}/data
CLUSTER_NAME=${CLUSTER_NAME:-"DivineOrder"}

# ---------------------------------------------------------

config="/opt/elasticsearch/config/elasticsearch.yml"

  cat << EOF > ${config}

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

  sed -i \
    -e "s|^#!/bin/bash|#!/bin/sh|g" \
    /opt/elasticsearch/bin/elasticsearch

  mkdir -p ${DATA_DIR}
  chown elastic: ${DATA_DIR}
  chmod ug+rwx ${DATA_DIR}

  mkdir -p /var/log/elasticsearch
  chown elastic: /var/log/elasticsearch
  chmod ug+rwx /var/log/elasticsearch


su --command /opt/elasticsearch/bin/elasticsearch elastic

# /opt/elasticsearch/bin/elasticsearch

# EOF
