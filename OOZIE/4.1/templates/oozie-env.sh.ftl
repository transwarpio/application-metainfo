#! /bin/bash

# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
export OOZIE_HOME=/usr/lib/oozie
export CATALINA_BASE=/usr/lib/oozie/oozie-server
export CATALINA_HOME=/usr/lib/oozie/oozie-server
export OOZIE_DATA=/var/lib/${service.sid}
export CATALINA_TMPDIR=/usr/lib/oozie/oozie-server/temp
export BASEDIR=/usr/lib/oozie

# Set Oozie specific environment variables here.

# Settings for the Embedded Tomcat that runs Oozie
# Java System properties for Oozie should be specified in this variable
#

<#if service['oozie.container.limits.memory'] != "-1" && service['oozie.memory.ratio'] != "-1">
  <#assign limitsMemory = service['oozie.container.limits.memory']?number
    memoryRatio = service['oozie.memory.ratio']?number
    oozieMemory = limitsMemory * memoryRatio * 1024>
<#else>
  <#assign oozieMemory = service['oozie.server.memory']?number>
</#if>
export CATALINA_OPTS="$CATALINA_OPTS -Xmx${oozieMemory?floor}m -agentpath:/usr/lib/hadoop/bin/libagent.so"

# Oozie configuration file to load from Oozie configuration directory
#
export OOZIE_CONFIG=/etc/${service.sid}/conf
export OOZIE_CONFIG_FILE=oozie-site.xml

# Oozie logs directory
#
export OOZIE_LOG=/var/log/${service.sid}

# Oozie Log4J configuration file to load from Oozie configuration directory
#
# export OOZIE_LOG4J_FILE=oozie-log4j.properties

# Reload interval of the Log4J configuration file, in seconds
#
# export OOZIE_LOG4J_RELOAD=10

# The port Oozie server runs
#
export OOZIE_HTTP_PORT=${service['oozie.http.port']}

# The port Oozie server runs if using SSL (HTTPS)
#
# export OOZIE_HTTPS_PORT=11443

# The host name Oozie server runs on
#
# export OOZIE_HTTP_HOSTNAME=`hostname -f`
<#noparse>
# The base URL for callback URLs to Oozie
#
# export OOZIE_BASE_URL="http://${OOZIE_HTTP_HOSTNAME}:${OOZIE_HTTP_PORT}/oozie"

# The location of the keystore for the Oozie server if using SSL (HTTPS)
#
# export OOZIE_HTTPS_KEYSTORE_FILE=${HOME}/.keystore
</#noparse>
# The password of the keystore for the Oozie server if using SSL (HTTPS)
#
# export OOZIE_HTTPS_KEYSTORE_PASS=password

export OOZIE_DATA=/var/lib/${service.sid}
export OOZIE_ADMIN_PORT=${service['oozie.admin.port']}
export OOZIE_HTTP_HOSTNAME=${localhostname}
export OOZIE_HTTP_PORT=${service['oozie.http.port']}
export OOZIE_HTTPS_PORT=${service['oozie.https.port']}
<#assign limitsMemory = service['oozie.container.limits.memory']?number
  memoryRatio = service['oozie.memory.ratio']?number
  memory = limitsMemory * memoryRatio * 1024>
export OOZIE_SERVER_MEMORY=${memory?floor}m

<#assign url="http://" + service.roles.OOZIE_SERVER[0]['hostname'] + ":" + service['oozie.http.port'] + "/oozie">
export OOZIE_BASE_URL=${url}

<#if dependencies.HDFS??>
    <#assign rpc_port=dependencies.HDFS['namenode.rpc-port']>
    <#if dependencies.HDFS.nameservices?? && dependencies.HDFS.nameservices?size gt 0>
        <#assign hdfs_nameservice=dependencies.HDFS.nameservices[0]>
    <#else>
        <#assign hdfs_nameservice=dependencies.HDFS.roles['HDFS_NAMENODE'][0].hostname>
    </#if>
</#if>
export HDFS_NAMESERVICE=${hdfs_nameservice}
export RPC_PORT=${rpc_port}
