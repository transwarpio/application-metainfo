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
<#if service.plugins?seq_contains("guardian")>
for f in /usr/lib/transwarp/plugins/guardian/slipstream/lib/*jar; do
if [ "HIVE_AUX_JARS_PATH" ]; then
export HIVE_AUX_JARS_PATH=$f:$HIVE_AUX_JARS_PATH
else
export HIVE_AUX_JARS_PATH=$f
fi
done
</#if>

export HADOOP_HEAPSIZE=${service['hive.memory']}
export INCEPTOR_SERVER_MEMORY=${service['hive.memory']}
export INCEPTOR_EXECUTOR_MEMORY=${service['hive.memory']}
export SPARK_CORES=${service['hive.cores']}
export HIVE_PORT=${service['hive.server2.thrift.port']}
export HADOOP_CONF_DIR=/etc/${dependencies.HDFS.sid}/conf:/etc/${dependencies.YARN.sid}/conf
export HBASE_CONF_DIR=/etc/${dependencies.HYPERBASE.sid}/conf
export HIVE_SERVER2="true"

<#--handle dependent.zookeeper-->
<#if dependencies.ZOOKEEPER??>
    <#assign zookeeper=dependencies.ZOOKEEPER quorums=[]>
    <#list zookeeper.roles.ZOOKEEPER as role>
        <#assign quorums += [role.hostname + ":" + zookeeper[role.hostname]["zookeeper.client.port"]]>
    </#list>
    <#assign quorum = quorums?join(",")>
</#if>
export INCEPTOR_LICENSE_ZOOKEEPER_QUORUM=${quorum}
export INCEPTOR_UI_PORT=${service['inceptor.ui.port']}
export METASTORE_PORT=${service['hive.metastore.port']}

<#if dependencies.ZOOKEEPER[.data_model["localhostname"]]??>
    <#if dependencies.ZOOKEEPER[.data_model["localhostname"]]['zookeeper.client.port']??>
    export TRANSWARP_ZOOKEEPER_PORT=${dependencies.ZOOKEEPER[.data_model["localhostname"]]['zookeeper.client.port']}
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
export HIVE_METASTORE_SERVER=${service.roles.INCEPTOR_METASTORE[0]['hostname']}
export SPARK_DRIVER_ADDR=${service.roles.INCEPTOR_SERVER[0]['hostname']}
export EXECUTOR_ID_PATH=/${service.sid}/executorID
export METASTORE_ID=metastore_${service.sid}

<#if service.auth = "kerberos">
    cp /etc/${service.sid}/conf/krb5.conf /etc
</#if>