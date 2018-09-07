export ZOOKEEPER_CONF_DIR=/etc/${service.sid}/conf
export ZOOKEEPER_LOG_DIR=/var/log/${service.sid}/zookeeper
export ZOOKEEPER_DATA_DIR=/var/${service.sid}/zookeeper
export SERVER_JVMFLAGS="-Dcom.sun.management.jmxremote.port=${service['zookeeper.jmxremote.port']} -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false $SERVER_JVMFLAGS"
export SERVER_JVMFLAGS="-Xmx${service['zookeeper.server.memory']?number?floor}m $SERVER_JVMFLAGS"
export SERVER_JVMFLAGS="-Dzookeeper.log.dir=/var/log/${service.sid}/zookeeper -Dzookeeper.root.logger=INFO,ROLLINGFILE $SERVER_JVMFLAGS"
