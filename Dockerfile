FROM zookeeper:3.5

RUN chmod -R 777 $ZOO_DATA_LOG_DIR $ZOO_DATA_DIR $ZOO_CONF_DIR
RUN chmod -R 777 /conf