#!/usr/bin/env bash

export KAFKA_DATA_DIRS=${service['kmq.log.dirs']}
export ZOOKEEPER_CONNECTION_TIMEOUT=${service['zookeeper.connection.timeout.ms']}
export MESSAGE_MAX_BYTES=${service['message.max.bytes']}
export REPLICA_FETCH_MAX_BYTES=${service['replica.fetch.max.bytes']}
export BROKER_ID_EQUALS_TO_DND_ID=${service['brokerid.equalsto.dndid']}
export KAFKA_LOG_DIR=/var/log/${service.sid}
export KAFKA_JMX_REMOTE_PORT=${service['kafka.jmx.remote.port']}
export KAFKA_SERVER_MEMORY=${service['kafka.broker.memory']}
<#if service.auth = "kerberos">
export KRB_OPTS="-Djava.security.krb5.conf=/etc/${service.sid}/conf/krb5.conf -Djava.security.auth.login.config=/etc/${service.sid}/conf/jaas.conf"
</#if>
