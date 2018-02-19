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

## Getting Started
Instantiating the Zookeeper Ensemble.
```
oc new-project zookeeper
oc create -f openshift/deployment.yaml
```

Clients are able to use Zookeeper through the `zookeeper-client` service. Test your ensemble with the following
commands.
```
oc rsh zookeeper-0 zkCli.sh create /foo 42
oc rsh zookeeper-2 zkCli.sh get /foo
```

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
Monitoring data can be obtained by sending `mntr` as the content of a TCP connection to the Zookeeper instance. THe data
returned is Prometheus compatible. You can use `echo "mntr" | nc zookper-1.zookeeper 2181` to obtain the data. 
```json
zk_version	3.4.11-37e277162d567b55a07d1755f0b31c32e93c01a0, built on 11/01/2017 18:06 GMT
zk_avg_latency	0
zk_max_latency	0
zk_min_latency	0
zk_packets_received	31
zk_packets_sent	30
zk_num_alive_connections	1
zk_outstanding_requests	0
zk_server_state	follower
zk_znode_count	8
zk_watch_count	0
zk_ephemerals_count	0
zk_approximate_data_size	338
zk_open_file_descriptor_count	29
zk_max_file_descriptor_count	1048576
```