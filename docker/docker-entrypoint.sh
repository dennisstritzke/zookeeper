#!/bin/bash

set -e

# Allow the container to be started with `--user`
if [[ "$1" = 'zkServer.sh' && "$(id -u)" = '0' ]]; then
    chown -R "$ZOO_USER" "$ZOO_DATA_DIR" "$ZOO_DATA_LOG_DIR"
    exec su-exec "$ZOO_USER" "$0" "$@"
fi

# Generate the config only if it doesn't exist
if [[ ! -f "$ZOO_CONF_DIR/zoo.cfg" ]]; then
    CONFIG="$ZOO_CONF_DIR/zoo.cfg"

    echo "dataDir=$ZOO_DATA_DIR" >> "$CONFIG"
    echo "dataLogDir=$ZOO_DATA_LOG_DIR" >> "$CONFIG"

    echo "tickTime=$ZOO_TICK_TIME" >> "$CONFIG"
    echo "initLimit=$ZOO_INIT_LIMIT" >> "$CONFIG"
    echo "syncLimit=$ZOO_SYNC_LIMIT" >> "$CONFIG"

    echo "maxClientCnxns=$ZOO_MAX_CLIENT_CNXNS" >> "$CONFIG"
    echo "standaloneEnabled=$ZOO_STANDALONE_ENABLED" >> "$CONFIG"

    if [[ -z $ZOO_SERVERS ]]; then
      ZOO_SERVERS="server.1=localhost:2888:3888;$ZOO_PORT"
    fi

    for server in $ZOO_SERVERS; do
        echo "$server" >> "$CONFIG"
    done
fi

# Write myid only if it doesn't exist
if [[ ! -f "$ZOO_DATA_DIR/myid" ]]; then
    echo "${ZOO_MY_ID:-1}" > "$ZOO_DATA_DIR/myid"
fi

T_HOSTNAME=$(hostname)
T_ID=$( echo ${T_HOSTNAME} | cut -d "-" -f2 | cut -d "-" -f1 )

# Allow time for our container to register with DNS.
sleep 10

# Get our 'zookeeper' peers through nslookup. This is locked to a service
# name exposed as 'zookeeper'. Could do better here and make nslookup more
# dynamic using a variable that contains the service name. 
# TODO: Have a bootstrap image that contains bind-utils and also knows
# the service name, performs nslookup and passes the list of PEERS to this
# script. We can then remove bind-utils from the zookeeper container image.  
PEERS=( $(nslookup zookeeper | grep -oE '[^ ]+$' | grep ^zookeeper-) )

# Output content of PEERS array to container log.
echo "Zookeeper PEERS:" ${PEERS[@]}

# No DNS PEERS, setup a default localhost else build PEERS config.
if [ ${#PEERS[@]} -eq 0 ]; then
  echo "server.0=localhost:2888:3888:participant;2181" >> /conf/zoo.cfg.dynamic
  T_MEMBERS="server.0=localhost:2888:3888:participant;2181"
else
  echo "\n\nBefore for loop\n\n"
  for PEER in "${PEERS[@]}"
  do
    echo "\n\nPeer: $PEER\n\n"
    P_HOSTNAME=$( echo ${PEER} | cut -d "." -f1 )
    P_ID=$( echo ${P_HOSTNAME} | cut -d "-" -f2 | cut -d "-" -f1 )
    P_MEMBER="server.${P_ID}=${PEER}:2888:3888:participant;2181"
    echo ${P_MEMBER} >> /conf/zoo.cfg.dynamic
    T_MEMBERS=${T_MEMBERS},${P_MEMBER}
  done
fi

# Trim any leading comma and output MEMBERS to container log. 
MEMBERS=${T_MEMBERS#\,}
echo "Zookeeper MEMBERS:" ${MEMBERS}

zkServer-initialize.sh --force --myid=${T_ID}

exec "$@"