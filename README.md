# Zookeeper Cluster on OpenShift using StatefulSet

## Monitor
### Server Status
```
wget -qO- localhost:8080/commands/stats
{
  "version" : "3.5.3-beta-8ce24f9e675cbefffb8f21a47e06b42864475a60, built on 04/03/2017 16:19 GMT",
  "read_only" : false,
  "server_stats" : {
    "packets_sent" : 0,
    "packets_received" : 0,
    "max_latency" : 0,
    "min_latency" : 0,
    "outstanding_requests" : 0,
    "avg_latency" : 0,
    "server_state" : "follower",
    "data_dir_size" : 699,
    "log_dir_size" : 699,
    "last_processed_zxid" : 0,
    "provider_null" : false,
    "num_alive_client_connections" : 0
  },
  "node_count" : 5,
  "connections" : [ ],
  "command" : "stats",
  "error" : null
}
```

### Monitoring
```
wget -qO- localhost:8080/commands/monitor
{
  "version" : "3.5.3-beta-8ce24f9e675cbefffb8f21a47e06b42864475a60, built on 04/03/2017 16:19 GMT",
  "avg_latency" : 0,
  "max_latency" : 0,
  "min_latency" : 0,
  "packets_received" : 0,
  "packets_sent" : 0,
  "num_alive_connections" : 0,
  "outstanding_requests" : 0,
  "server_state" : "follower",
  "znode_count" : 5,
  "watch_count" : 0,
  "ephemerals_count" : 0,
  "approximate_data_size" : 325,
  "open_file_descriptor_count" : 46,
  "max_file_descriptor_count" : 1048576,
  "command" : "monitor",
  "error" : null
}
