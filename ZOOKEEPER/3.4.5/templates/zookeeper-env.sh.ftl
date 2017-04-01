#!/usr/bin/env bash

<<<<<<< HEAD
export ZOOKEEPER_LOG_DIR=/var/log/${service.sid}
export ZOOKEEPER_DATA_DIR=/var/${service.sid}
=======
export ZOOKEEPER_LOG=/var/log/${service.sid}
>>>>>>> WARP-11575: Kafka connection check

export SERVER_JVMFLAGS="-Dcom.sun.management.jmxremote.port=${service['zookeeper.jmxremote.port']} -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false"
<#if service['zookeeper.server.memory']??>
export SERVER_JVMFLAGS="-Xmx${service['zookeeper.server.memory']}m $SERVER_JVMFLAGS"
</#if>
<<<<<<< HEAD
export SERVER_JVMFLAGS="-Dzookeeper.log.dir=/var/log/${service.sid} -Dzookeeper.root.logger=INFO,ROLLINGFILE $SERVER_JVMFLAGS"
<#if service.auth == "kerberos">
export SERVER_JVMFLAGS="$SERVER_JVMFLAGS -Djava.security.auth.login.config=$ZOOKEEPER_CONF/jaas.conf -Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.local.only=false"
</#if>
export JAVAAGENT_OPTS=" -javaagent:/usr/lib/jmx_exporter/jmx_prometheus_javaagent-0.7.jar=5556:/usr/lib/jmx_exporter/agentconfig.yml "
=======
export SERVER_JVMFLAGS="-Dzookeeper.log.dir=$ZOOKEEPER_LOG -Dzookeeper.root.logger=INFO,ROLLINGFILE $SERVER_JVMFLAGS"
<#if service.auth == "kerberos">
export SERVER_JVMFLAGS="$SERVER_JVMFLAGS -Djava.security.auth.login.config=$ZOOKEEPER_CONF/jaas.conf -Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.local.only=false"
</#if>
<#if service[.data_model["localhostname"]]['zookeeper.peer.communicate.port']??>
export ZOOKEEPER_PEER_COMMUNICATE_PORT=${service[.data_model["localhostname"]]['zookeeper.peer.communicate.port']}
export ZOOKEEPER_LEADER_ELECT_PORT=${service[.data_model["localhostname"]]['zookeeper.leader.elect.port']}
</#if>
>>>>>>> WARP-11575: Kafka connection check
