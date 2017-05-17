#!/usr/bin/env bash

export ZOOKEEPER_LOG_DIR=/var/log/${service.sid}
export ZOOKEEPER_DATA_DIR=/var/${service.sid}

export SERVER_JVMFLAGS="-Dcom.sun.management.jmxremote.port=${service['zookeeper.jmxremote.port']} -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false"
<#assign limitsMemory = service['zookeeper.container.limits.memory']?number
         memoryRatio = service['zookeeper.memory.ratio']?number
         memory = limitsMemory * memoryRatio * 1024>
export SERVER_JVMFLAGS="-Xmx${memory?floor}m $SERVER_JVMFLAGS"

export SERVER_JVMFLAGS="-Dzookeeper.log.dir=/var/log/${service.sid} -Dzookeeper.root.logger=INFO,ROLLINGFILE $SERVER_JVMFLAGS"
<#if service.auth == "kerberos">
export SERVER_JVMFLAGS="$SERVER_JVMFLAGS -Djava.security.auth.login.config=$ZOOKEEPER_CONF/jaas.conf -Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.local.only=false"
</#if>
export JAVAAGENT_OPTS=" -javaagent:/usr/lib/jmx_exporter/jmx_prometheus_javaagent-0.7.jar=5557:/usr/lib/jmx_exporter/agentconfig.yml "
