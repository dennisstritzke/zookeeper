# Zookeeper Ensemble on OpenShift using StatefulSet
> ZooKeeper is a centralized service for maintaining configuration information, naming, providing distributed
> synchronization, and providing group services. All of these kinds of services are used in some form or another by
> distributed applications. Each time they are implemented there is a lot of work that goes into fixing the bugs and
> race conditions that are inevitable. Because of the difficulty of implementing these kinds of services, applications
> initially usually skimp on them ,which make them brittle in the presence of change and difficult to manage. Even when
> done correctly, different implementations of these services lead to management complexity when the applications are
> deployed.

Taken from the [Apache Zookeeper Project Page](http://zookeeper.apache.org). This project contains an OpenShift ready
deployment of Zookeeper.  

## Considerations
### Static Ensemble
The deployed ensemble consists out of three Zookeeper instances, which is statically defined. Using this deployment you
are able to specify a different number of instances, but a redeployment is required. A dynamic ensemble scaling isn't
supported as it is an alpha feature and Zookeeper doesn't recommend dynamic ensemble changes for production.

## Data and Data Log directory
This deployment uses two PVCs for the data and data log directory, which will most likely be on the same storage device.
Zookeeper recommends putting these directories on different storage devices for best performance. If you are running a
read / write intensive Zookeeper workload execute load tests before using this deployment.

## Monitoring
Configure your monitoring system to scrape all Zookeeper instances with an HTTP GET to
`http://<instance>:8080/commands/monitor`. The endpoint will return monitoring data in a Prometheus compatible format.
```json
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
```