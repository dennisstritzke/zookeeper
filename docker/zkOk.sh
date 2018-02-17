#!/bin/bash

ZK_COMMAND_PORT=${ZK_COMMAND_PORT:-8080}
OK=$(wget -qO- http://localhost:${ZK_COMMAND_PORT}/commands/ruok | jq '.error')
if [ "$OK" == "null" ]; then
	exit 0
else
	exit 1
fi