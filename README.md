# docker-elasticsearch



## Hint

In particular, the message `max virtual memory areas vm.max_map_count [65530] likely too low, increase to at least [262144]` means
that the host's limits on mmap counts **must** be set to at least 262144.

Use `sysctl vm.max_map_count` on the host to view the current value, and see [Elasticsearch's documentation on virtual memory](https://www.elastic.co/guide/en/elasticsearch/reference/5.0/vm-max-map-count.html#vm-max-map-count) for guidance on how to change this value.

Note that the limits **must be changed on the host**; they cannot be changed from within a container.

