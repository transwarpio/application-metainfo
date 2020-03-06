#!/bin/bash
set -x

SHIVA_HOME=/usr/lib/shiva-webserver

JAVA_HOME=/usr/java/jdk1.8.0_111/
if [ -x "$JAVA_HOME/bin/java" ]; then
    JAVA="$JAVA_HOME/bin/java"
else
    JAVA=`which java`
fi

<#if service['shiva.webserver.container.limits.memory'] != "-1" && service['shiva.webserver.memory.ratio'] != "-1">
  <#assign limitsMemory = service['shiva.webserver.container.limits.memory']?number
    memoryRatio = service['shiva.webserver.memory.ratio']?number
    memory = limitsMemory * memoryRatio>
JAVA_OPTS="$JAVA_OPTS -Xms${(memory/2)?floor}g -Xmx${memory?floor}g"
<#else>
JAVA_OPTS="$JAVA_OPTS -Xms2g -Xmx${service['shiva.webserver.memory']}g"
</#if>

JAVA_OPTS="$JAVA_OPTS -Dmaster_group=$MASTER_GROUP -Dhttp_port=${service['shiva.http.port']} -Dconf=/etc/${service.sid}/conf/webserver_master_group"

if [ ! -x "$JAVA" ]; then
    echo "Could not find any executable java binary. Please install java in your PATH or set JAVA_HOME"
    exit 1
fi

$JAVA $JAVA_OPTS -cp ".:/etc/${service.sid}/conf/shiva:$SHIVA_HOME/lib/*" io.transwarp.shiva.rest.ShivaWebServer

