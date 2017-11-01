# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Set Hive and Hadoop environment variables here. These variables can be used
# to control the execution of Hive. It should be used by admins to configure
# the Hive installation (so that users do not have to set environment variables
# or set command line parameters to get correct behavior).
#
# The hive service being invoked (CLI/HWI etc.) is available via the environment
# variable SERVICE


# Hive Client memory usage can be an issue if a large number of clients
# are running at the same time. The flags below have been useful in
# reducing memory usage:
#
# if [ "$SERVICE" = "cli" ]; then
#   if [ -z "$DEBUG" ]; then
#     export HADOOP_OPTS="$HADOOP_OPTS -XX:NewRatio=12 -Xms10m -XX:MaxHeapFreeRatio=40 -XX:MinHeapFreeRatio=15 -XX:+UseParNewGC -XX:-UseGCOverheadLimit"
#   else
#     export HADOOP_OPTS="$HADOOP_OPTS -XX:NewRatio=12 -Xms10m -XX:MaxHeapFreeRatio=40 -XX:MinHeapFreeRatio=15 -XX:-UseGCOverheadLimit"
#   fi
# fi

# The heap size of the jvm stared by hive shell script can be controlled via:
#
# export HADOOP_HEAPSIZE=1024
#
# Larger heap size may be required when running queries over large number of files or partitions.
# By default hive shell scripts use a heap size of 256 (MB).  Larger heap size would also be
# appropriate for hive server (hwi etc).


# Set HADOOP_HOME to point to a specific hadoop install directory
# HADOOP_HOME=${r"${bin}"}/../../hadoop

# Hive Configuration Directory can be controlled by:
# export HIVE_CONF_DIR=

# Folder containing extra ibraries required for hive compilation/execution can be controlled by:

<#if service['server.container.limits.memory'] != "-1" && service['server.memory.ratio'] != "-1">
  <#assign limitsMemory = service['server.container.limits.memory']?number
    memoryRatio = service['server.memory.ratio']?number
    serverMemory = limitsMemory * memoryRatio * 1024>
<#else>
  <#if service[.data_model["localhostname"]]['inceptor.server.memory']??>
    <#assign serverMemory=service[.data_model["localhostname"]]['inceptor.server.memory']?trim?number>
  <#else>
    <#assign serverMemory=8192>
  </#if>
</#if>
export INCEPTOR_SERVER_MEMORY=${serverMemory?floor}

<#if service.plugins?seq_contains("governor")>
for f in /usr/lib/transwarp/plugins/governor/inceptor/lib/*jar; do
if [ "HIVE_AUX_JARS_PATH" ]; then
export HIVE_AUX_JARS_PATH=$f:$HIVE_AUX_JARS_PATH
else
export HIVE_AUX_JARS_PATH=$f
fi
done
export EXTRA_JAVA_OPTS="-Djava.security.auth.login.config=/etc/${service.sid}/conf/kafka_client_jaas.conf"
</#if>

# TODO get executor memory from resource configuration
<#if service['executor.container.limits.memory'] != "-1" && service['executor.memory.ratio'] != "-1">
  <#assign limitsMemory = service['executor.container.limits.memory']?number
    memoryRatio = service['executor.memory.ratio']?number
    executorMemory = limitsMemory * memoryRatio * 1024>
<#else>
  <#if service[.data_model["localhostname"]]['inceptor.executor.memory']??>
    <#assign executorMemory=service[.data_model["localhostname"]]['inceptor.executor.memory']?trim?number>
  <#else>
    <#assign executorMemory=32000>
  </#if>
</#if>
export INCEPTOR_EXECUTOR_MEMORY=${executorMemory?floor}

<#if service['executor.container.limits.cpu'] != "-1">
  <#assign sparkCores=service['executor.container.limits.cpu']>
<#else>
  <#if service[.data_model["localhostname"]]['inceptor.executor.cores']??>
    <#assign sparkCores=service[.data_model["localhostname"]]['inceptor.executor.cores']?trim?number>
  <#else>
    <#assign sparkCores=10>
  </#if>
</#if>
export SPARK_CORES=${sparkCores}

<#if service['metastore.container.limits.memory'] != "-1" && service['metastore.memory.ratio'] != "-1">
  <#assign limitsMemory = service['metastore.container.limits.memory']?number
    memoryRatio = service['metastore.memory.ratio']?number
    metastoreMemory = limitsMemory * memoryRatio * 1024>
<#else>
  <#if service[.data_model["localhostname"]]['inceptor.metastore.memory']??>
    <#assign metastoreMemory=service[.data_model["localhostname"]]['inceptor.metastore.memory']?trim?number>
  <#else>
    <#assign metastoreMemory=8192>
  </#if>
</#if>
export INCEPTOR_METASTORE_MEMORY=${metastoreMemory?floor}

export HIVE_PORT=${service['hive.server2.thrift.port']}

export HADOOP_CONF_DIR=/etc/${dependencies.HDFS.sid}/conf:/etc/${dependencies.YARN.sid}/conf
<#if dependencies.HYPERBASE??>
export HBASE_CONF_DIR=/etc/${dependencies.HYPERBASE.sid}/conf
</#if>
export HIVE_SERVER2="true"

<#--handle dependent.zookeeper-->
<#if dependencies.ZOOKEEPER??>
    <#assign zookeeper=dependencies.ZOOKEEPER quorums=[]>
    <#list zookeeper.roles.ZOOKEEPER as role>
        <#assign quorums += [role.hostname + ":" + zookeeper["zookeeper.client.port"]]>
    </#list>
    <#assign quorum = quorums?join(",")>
</#if>
export INCEPTOR_LICENSE_ZOOKEEPER_QUORUM=${quorum}
export INCEPTOR_UI_PORT=${service['inceptor.ui.port']}
<#if dependencies.INCEPTOR??>
export METASTORE_PORT=${dependencies.INCEPTOR['hive.metastore.port']}
<#else>
export METASTORE_PORT=${service['hive.metastore.port']}
</#if>

<#if dependencies.ZOOKEEPER??>
    <#if dependencies.ZOOKEEPER['zookeeper.client.port']??>
export TRANSWARP_ZOOKEEPER_PORT=${dependencies.ZOOKEEPER['zookeeper.client.port']}
    </#if>
</#if>

<#assign hostPorts = []>
<#assign txsql = dependencies['TXSQL']>
<#list txsql.roles['TXSQL_SERVER'] as r>
  <#assign hostPorts = hostPorts + [r.hostname + ':' + txsql['mysql.rw.port']]>
</#list>
export MYSQL_SERVER_PORT=${hostPorts?join(",")}
export JAVAX_JDO_OPTION_CONNECTIONURL=jdbc:mysql://${hostPorts?join(",")}/metastore_${service.sid}
export JAVAX_JDO_OPTION_CONNECTION_USERNAME=${service['javax.jdo.option.ConnectionUserName']}
export JAVAX_JDO_OPTION_CONNECTION_PASSWORD=${service['javax.jdo.option.ConnectionPassword']}
<#if dependencies.INCEPTOR??>
export HIVE_METASTORE_SERVER=${dependencies.INCEPTOR.roles.INCEPTOR_METASTORE[0]['hostname']}
<#else>
export HIVE_METASTORE_SERVER=${service.roles.INCEPTOR_METASTORE[0]['hostname']}
</#if>
export SPARK_DRIVER_ADDR=${service.roles.INCEPTOR_SERVER[0]['hostname']}
export EXECUTOR_ID_PATH=/${service.sid}/executorID
export METASTORE_ID=metastore_${service.sid}

<#if service.plugins?seq_contains("guardian")>
cp /etc/${service.sid}/conf/krb5.conf /etc
export MASTERPRINCIPAL=hive/${localhostname}
export KEYTAB=/etc/${service.sid}/conf/inceptor.keytab
export KRB_PLUGIN_ENABLE=true
</#if>

# security environment
<#if service.auth = "kerberos">
cp /etc/${service.sid}/conf/krb5.conf /etc
export KRB_ENABLE=true
export EXECUTOR_PRINCIPAL=hive/_HOST@${service.realm}
export EXECUTOR_KEYTAB=/etc/${service.sid}/conf/inceptor.keytab
export MASTERPRINCIPAL=hive/${localhostname}
export KEYTAB=/etc/${service.sid}/conf/inceptor.keytab
export KRB_PLUGIN_ENABLE=true
<#else>
export KRB_ENABLE=false
</#if>

<#if dependencies.RUBIK??>
cp /etc/${dependencies.RUBIK.sid}/conf/dataSource.properties /etc/${service.sid}/conf/
chmod 600 /etc/${service.sid}/conf/dataSource.properties
chown hive:hive /etc/${service.sid}/conf/dataSource.properties
</#if>
