#!/usr/bin/env bash

export KAFKA_DATA_DIRS=${service['kmq.log.dirs']}
export ZOOKEEPER_CONNECTION_TIMEOUT=${service['kmq.zookeeper.connection.timeout.ms']}
export MESSAGE_MAX_BYTES=${service['kmq.message.max.bytes']}
export REPLICA_FETCH_MAX_BYTES=${service['kmq.replica.fetch.max.bytes']}
export BROKER_ID_EQUALS_TO_DND_ID=${service['brokerid.equalsto.dndid']}
export KAFKA_LOG_DIRS=/var/log/${service.sid}
export KAFKA_JMX_REMOTE_PORT=${service['kafka.jmx.remote.port']}
