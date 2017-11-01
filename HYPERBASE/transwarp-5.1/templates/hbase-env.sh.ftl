#
#/**
# * Copyright 2007 The Apache Software Foundation
# *
# * Licensed to the Apache Software Foundation (ASF) under one
# * or more contributor license agreements.  See the NOTICE file
# * distributed with this work for additional information
# * regarding copyright ownership.  The ASF licenses this file
# * to you under the Apache License, Version 2.0 (the
# * "License"); you may not use this file except in compliance
# * with the License.  You may obtain a copy of the License at
# *
# *     http://www.apache.org/licenses/LICENSE-2.0
# *
# * Unless required by applicable law or agreed to in writing, software
# * distributed under the License is distributed on an "AS IS" BASIS,
# * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# * See the License for the specific language governing permissions and
# * limitations under the License.
# */

# Set environment variables here.
export HBASE_CONF_DIR=/etc/${service.sid}/conf
export HADOOP_CONF_DIR=/etc/${dependencies.HDFS.sid}/conf:/etc/${dependencies.YARN.sid}/conf

# The java implementation to use.  Java 1.6 required.
# export JAVA_HOME=/usr/java/jdk1.6.0/

# Extra Java CLASSPATH elements.  Optional.
export HBASE_CLASSPATH=/etc/${dependencies.HDFS.sid}/conf

export HADOOP_MAPRED_HOME=/usr/lib/hadoop-mapreduce

# Extra Java runtime options.
# Below are what we set by default.  May only work with SUN JVM.
# For more on why as well as other possible settings,
# see http://wiki.apache.org/hadoop/PerformanceTuning
export HBASE_OPTS="$HBASE_OPTS -XX:+HeapDumpOnOutOfMemoryError -XX:+UseConcMarkSweepGC -XX:CMSInitiatingOccupancyFraction=80 -XX:+CMSClassUnloadingEnabled -XX:+ExplicitGCInvokesConcurrent -XX:+UseCMSCompactAtFullCollection -XX:CMSFullGCsBeforeCompaction=0"

export HBASE_OPTS="$HBASE_OPTS -XX:+UseParNewGC -XX:NewRatio=3 -XX:NewSize=512m"

# For jdk8
#export HBASE_OPTS="$HBASE_OPTS -ea -XX:+HeapDumpOnOutOfMemoryError"
#export HBASE_OPTS="$HBASE_OPTS -XX:+UnlockExperimentalVMOptions -XX:+UseG1GC -XX:MaxGCPauseMillis=50 -XX:GCPauseIntervalMillis=200 -XX:SurvivorRatio=6"



# Uncomment below to enable java garbage collection logging.
# export HBASE_OPTS="$HBASE_OPTS -verbose:gc -XX:+PrintGCDetails -XX:+PrintGCDateStamps -Xloggc:$HBASE_HOME/logs/gc-hbase.log"

# Uncomment and adjust to enable JMX exporting
# See jmxremote.password and jmxremote.access in $JRE_HOME/lib/management to configure remote password access.
# More details at: http://java.sun.com/javase/6/docs/technotes/guides/management/agent.html
#
# export HBASE_JMX_BASE="-Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=false"
# export HBASE_MASTER_OPTS="$HBASE_MASTER_OPTS $HBASE_JMX_BASE -Dcom.sun.management.jmxremote.port=10101"
# export HBASE_REGIONSERVER_OPTS="$HBASE_REGIONSERVER_OPTS $HBASE_JMX_BASE -Dcom.sun.management.jmxremote.port=10102"
# export HBASE_THRIFT_OPTS="$HBASE_THRIFT_OPTS $HBASE_JMX_BASE -Dcom.sun.management.jmxremote.port=10103"
# export HBASE_ZOOKEEPER_OPTS="$HBASE_ZOOKEEPER_OPTS $HBASE_JMX_BASE -Dcom.sun.management.jmxremote.port=10104"

HBASE_JMX_OPTS="-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.ssl=false"
HBASE_JMX_OPTS="$HBASE_JMX_OPTS -Dcom.sun.management.jmxremote.password.file=$HBASE_CONF_DIR/jmxremote.passwd"
HBASE_JMX_OPTS="$HBASE_JMX_OPTS -Dcom.sun.management.jmxremote.access.file=$HBASE_CONF_DIR/jmxremote.access"
export HBASE_MASTER_OPTS="$HBASE_JMX_OPTS -Dcom.sun.management.jmxremote.port=${service['master.jmx.port']}"
export HBASE_REGIONSERVER_OPTS="$HBASE_JMX_OPTS -Dcom.sun.management.jmxremote.port=${service['regionserver.jmx.port']}"

<#if service['master.container.limits.memory'] != "-1" && service['master.memory.ratio'] != "-1">
  <#assign limitsMemory = service['master.container.limits.memory']?number
    memoryRatio = service['master.memory.ratio']?number
    masterMemory = limitsMemory * memoryRatio * 1024>
<#else>
  <#if service[.data_model["localhostname"]]['master.memory']??>
    <#assign masterMemory=service[.data_model["localhostname"]]['master.memory']?trim?number>
  <#else>
    <#assign masterMemory=24000>
  </#if>
</#if>
export HBASE_MASTER_MEMORY=${masterMemory?floor}m
export HBASE_MASTER_OPTS="$HBASE_MASTER_OPTS -Xmx${masterMemory?floor}m"

<#if service['regionserver.container.limits.memory'] != "-1" && service['regionserver.memory.ratio'] != "-1">
  <#assign limitsMemory = service['regionserver.container.limits.memory']?number
    memoryRatio = service['regionserver.memory.ratio']?number
    regionserverMemory = limitsMemory * memoryRatio * 1024>
<#else>
  <#if service[.data_model["localhostname"]]['regionserver.memory']??>
    <#assign regionserverMemory=service[.data_model["localhostname"]]['regionserver.memory']?trim?number>
  <#else>
    <#assign regionserverMemory=24000>
  </#if>
</#if>
export HBASE_REGIONSERVER_MEMORY=${regionserverMemory?floor}m
export HBASE_REGIONSERVER_OPTS="$HBASE_REGIONSERVER_OPTS -Xms${(regionserverMemory/2)?floor}m -Xmx${regionserverMemory?floor}m -verbose:gc -XX:+PrintGCDetails -XX:+PrintGCDateStamps -XX:+PrintGCTimeStamps"

<#if service['thrift.container.limits.memory'] != "-1" && service['thrift.memory.ratio'] != "-1">
  <#assign limitsMemory = service['thrift.container.limits.memory']?number
    memoryRatio = service['thrift.memory.ratio']?number
    thriftMemory = limitsMemory * memoryRatio * 1024>
<#else>
  <#if service[.data_model["localhostname"]]['thrift.memory']??>
    <#assign thriftMemory=service[.data_model["localhostname"]]['thrift.memory']?trim?number>
  <#else>
    <#assign thriftMemory=24000>
  </#if>
</#if>
export HBASE_THRIFT_SERVER_MEMORY=${thriftMemory?floor}m
export HBASE_THRIFT_OPTS="$HBASE_THRIFT_OPTS -Xmx${thriftMemory?floor}m"

#other roles heap size has been set in opts, chronos server do not set specific the java opts, use hbase heapsize instead.
export HBASE_HEAPSIZE="1024m"

# File naming hosts on which HRegionServers will run.  $HBASE_HOME/conf/regionservers by default.
# export HBASE_REGIONSERVERS=${r"${HBASE_HOME}"}/conf/regionservers

# Extra ssh options.  Empty by default.
# export HBASE_SSH_OPTS="-o ConnectTimeout=1 -o SendEnv=HBASE_CONF_DIR"

# Where log files are stored.  $HBASE_HOME/logs by default.
export HBASE_LOG_DIR=/var/log/${service.sid}

# A string representing this instance of hbase. $USER by default.
# export HBASE_IDENT_STRING=$USER

# The scheduling priority for daemon processes.  See 'man nice'.
# export HBASE_NICENESS=10

# The directory where pid files are stored. /tmp by default.
export HBASE_PID_DIR=/var/run/${service.sid}

# Seconds to sleep between slave commands.  Unset by default.  This
# can be useful in large clusters, where, e.g., slave rsyncs can
# otherwise arrive faster than the master can service them.
# export HBASE_SLAVE_SLEEP=0.1

# Tell HBase whether it should manage it's own instance of Zookeeper or not.
export HBASE_MANAGES_ZK=false

<#if dependencies.SEARCH??>
export DEPEND_ON_ES=true
export DISCOVERY_ZEN_PINT_UNICAST_HOSTS=
export ES_PORT=
<#else>
export DEPEND_ON_ES=false
</#if>

export HBASE_ZOOKEEPER_ZNODE_PARENT=/${service.sid}

<#if service.plugins?seq_contains("guardian")>
cp /etc/${service.sid}/conf/krb5.conf /etc
export MASTERPRINCIPAL=hbase/${localhostname}
export KEYTAB=/etc/${service.sid}/conf/hyperbase.keytab
export KRB_PLUGIN_ENABLE=true
</#if>

<#if service.auth = "kerberos">
cp /etc/${service.sid}/conf/krb5.conf /etc
export MASTERPRINCIPAL=hbase/${localhostname}
export KEYTAB=/etc/${service.sid}/conf/hyperbase.keytab
export KRB_PLUGIN_ENABLE=true
</#if>
