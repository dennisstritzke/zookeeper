#!/bin/bash

ZK_CLIENT_PORT=${ZK_CLIENT_PORT:-2181}
OK=$(echo "ruok" | nc localhost ${ZK_CLIENT_PORT})
if [ "$OK" == "imok" ]; then
	exit 0
else
	exit 1
fi