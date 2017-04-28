#!/usr/bin/env bash
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

# Set Hadoop-specific environment variables here.

# The only required environment variable is JAVA_HOME.  All others are
# optional.  When running a distributed configuration it is best to
# set JAVA_HOME in this file, so that it is correctly defined on
# remote nodes.

# The java implementation to use.
# export JAVA_HOME=${r"${JAVA_HOME}"}/bin
export JAVA_HOME=/usr/java/latest

# The jsvc implementation to use. Jsvc is required to run secure datanodes.

export HADOOP_CONF_DIR=/etc/${service.sid}/conf


# Extra Java CLASSPATH elements.  Automatically insert capacity-scheduler.
for f in $HADOOP_HOME/contrib/capacity-scheduler/*.jar; do
if [ "$HADOOP_CLASSPATH" ]; then
export HADOOP_CLASSPATH=$HADOOP_CLASSPATH:$f
else
export HADOOP_CLASSPATH=$f
fi
done

<#if service.plugins?seq_contains("guardian")>
for f in /usr/lib/transwarp/plugins/guardian/hdfs/lib/*jar; do
if [ "$HADOOP_CLASSPATH" ]; then
export HADOOP_CLASSPATH=$f:$HADOOP_CLASSPATH
else
export HADOOP_CLASSPATH=$f
fi
done
</#if>

# The maximum amount of heap to use, in MB. Default is 1000.
#export HADOOP_HEAPSIZE=
#export HADOOP_NAMENODE_INIT_HEAPSIZE=""

# Extra Java runtime options.  Empty by default.
export HADOOP_OPTS="$HADOOP_OPTS -Djava.net.preferIPv4Stack=true $HADOOP_CLIENT_OPTS"

# Command specific options appended to HADOOP_OPTS when specified
<#if service[.data_model["localhostname"]]['namenode.memory']??>
  <#assign NAMENODE_MEMORY=service[.data_model["localhostname"]]['namenode.memory']?trim>
<#else>
  <#assign NAMENODE_MEMORY=24000>
</#if>
<#if service[.data_model["localhostname"]]['datanode.memory']??>
  <#assign DATANODE_MEMORY=service[.data_model["localhostname"]]['datanode.memory']>
<#else>
  <#assign DATANODE_MEMORY=4096>
</#if>
<#if service[.data_model["localhostname"]]['journalnode.memory']??>
  <#assign JOURNALNODE_MEMORY=service[.data_model["localhostname"]]['journalnode.memory']>
<#else>
  <#assign JOURNALNODE_MEMORY=4096>
</#if>
# Export role memory
export NAMENODE_MEMORY=${NAMENODE_MEMORY}m
export DATANODE_MEMORY=${DATANODE_MEMORY}m
export JOURNALNODE_MEMORY=${JOURNALNODE_MEMORY}m
export HADOOP_NAMENODE_OPTS="-Xmx${NAMENODE_MEMORY}m -XX:+UseConcMarkSweepGC -XX:+ExplicitGCInvokesConcurrent -Dcom.sun.management.jmxremote $HADOOP_NAMENODE_OPTS"
export HADOOP_SECONDARYNAMENODE_OPTS="-Xmx${NAMENODE_MEMORY}m -Dcom.sun.management.jmxremote $HADOOP_SECONDARYNAMENODE_OPTS"
export HADOOP_DATANODE_OPTS="-Xmx${DATANODE_MEMORY}m -Dcom.sun.management.jmxremote $HADOOP_DATANODE_OPTS"
export HADOOP_BALANCER_OPTS="-Xmx4096m -Dcom.sun.management.jmxremote $HADOOP_BALANCER_OPTS"
export HADOOP_JOURNALNODE_OPTS="-Xmx${JOURNALNODE_MEMORY}m $HADOOP_JOURNALNODE_OPTS"


# The ZKFC does not need a large heap, and keeping it small avoids
# any potential for long GC pauses
export HADOOP_ZKFC_OPTS="-Xmx256m $HADOOP_ZKFC_OPTS"

# The following applies to multiple commands (fs, dfs, fsck, distcp etc)
#export HADOOP_CLIENT_OPTS="-Xmx128m $HADOOP_CLIENT_OPTS"
#HADOOP_JAVA_PLATFORM_OPTS="-XX:-UsePerfData $HADOOP_JAVA_PLATFORM_OPTS"

# On secure datanodes, user to run the datanode as after dropping privileges
export HADOOP_SECURE_DN_USER=${r"${HADOOP_SECURE_DN_USER}"}

# Where log files are stored.  $HADOOP_HOME/logs by default.
export HADOOP_LOG_DIR=/var/log/${service.sid}

# Where log files are stored in the secure data environment.
export HADOOP_SECURE_DN_LOG_DIR=${r"${HADOOP_LOG_DIR}"}

# The directory where pid files are stored. /tmp by default.
export HADOOP_PID_DIR=/var/run/${service.sid}
export HADOOP_SECURE_DN_PID_DIR=${r"${HADOOP_PID_DIR}"}

# A string representing this instance of hadoop. $USER by default.
#export HADOOP_IDENT_STRING=$USER

export CLUSTER=${service.sid}

<#if service.nameservices??>
  <#list service.nameservices as nameservice>
    <#assign namenodes=service[nameservice]["HDFS_NAMENODE"]>
    <#if namenodes?size == 1>
      <#if namenodes[0].id == .data_model["role.id"]>
export NAMENODE_NAMESERVICE=${nameservice}
export HDFS_HA=false
      </#if>
    <#elseif namenodes?size == 2>
      <#if namenodes[0].id lt namenodes[1].id>
        <#assign nn1=namenodes[0]>
        <#assign nn2=namenodes[1]>
      <#else>
        <#assign nn1=namenodes[1]>
        <#assign nn2=namenodes[0]>
      </#if>

      <#if nn1.id == .data_model["role.id"]>
export NAMENODE_NAMESERVICE=${nameservice}
export HDFS_HA=true
export NAMENODE_ORDINAL=0
      <#elseif nn2.id == .data_model["role.id"]>
export NAMENODE_NAMESERVICE=${nameservice}
export HDFS_HA=true
export NAMENODE_ORDINAL=1
        <#if service["namenode.http-port"]??>
          <#assign nn1HttpPort=service["namenode.http-port"]>
        </#if>
export NAMENODE_PRIMARY_JMX_URL=http://${nn1.hostname}:${nn1HttpPort}/jmx
      </#if>
    <#else>
      <#stop "more than 2 NameNodes in the same NameService not supported">
    </#if>
  </#list>
</#if>

<#if service["HDFS_NAMENODE"]??>
  <#list service["HDFS_NAMENODE"] as namenode>
    <#if namenode.id == .data_model["role.id"]>
export HDFS_HA=false
    </#if>
  </#list>
</#if>

# Export journalnode config
<#if service['journalnode.http-port']??>
export JOURNALNODE_HTTP_PORT=${service['journalnode.http-port']}
export JOURNALNODE_RPC_PORT=${service['journalnode.rpc-port']}
export HDFS_JOURNAL_NODE_COUNT=${service.roles.HDFS_JOURNALNODE?size}
</#if>

# Export dfs.datanode.data.dir
<#if service[.data_model["localhostname"]]['dfs.datanode.data.dir']??>
export DATANODE_DATA_DIRS=${service[.data_model["localhostname"]]['dfs.datanode.data.dir']}
<#else>
export DATANODE_DATA_DIRS=/vdir/hadoop/data
</#if>

# Export dfs.namenode.name.dir
<#if service[.data_model["localhostname"]]['dfs.namenode.name.dir']??>
export NAMENODE_DATA_DIRS=${service[.data_model["localhostname"]]['dfs.namenode.name.dir']}
<#else>
export NAMENODE_DATA_DIRS=/vdir/hadoop/hadoop_image,/vdir/hadoop/namenode_dir
</#if>

<#if service.auth = "kerberos">
cp /etc/${service.sid}/conf/krb5.conf /etc/
</#if>
