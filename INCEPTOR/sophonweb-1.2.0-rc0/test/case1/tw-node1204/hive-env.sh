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
# HADOOP_HOME=${bin}/../../hadoop

# Hive Configuration Directory can be controlled by:
# export HIVE_CONF_DIR=

# Folder containing extra ibraries required for hive compilation/execution can be controlled by:

export INCEPTOR_SERVER_MEMORY=8192


# TODO get executor memory from resource configuration
export INCEPTOR_EXECUTOR_MEMORY=7943

export SPARK_CORES=10

export INCEPTOR_METASTORE_MEMORY=4096

export HIVE_PORT=10000

export HADOOP_CONF_DIR=/etc/hdfs1/conf:/etc/yarn1/conf
export HBASE_CONF_DIR=/etc/hyperbase1/conf
export HIVE_SERVER2="true"

export INCEPTOR_LICENSE_ZOOKEEPER_QUORUM=tw-node1204:2181,tw-node1205:2181,tw-node1206:2181
export INCEPTOR_UI_PORT=4040
export METASTORE_PORT=9083

export TRANSWARP_ZOOKEEPER_PORT=2181

export MYSQL_SERVER_PORT=tw-node1204:3316,tw-node1205:3316,tw-node1206:3316
export JAVAX_JDO_OPTION_CONNECTIONURL=jdbc:mysql://tw-node1204:3316,tw-node1205:3316,tw-node1206:3316/metastore_inceptor1
export JAVAX_JDO_OPTION_CONNECTION_USERNAME=inceptoruser
export JAVAX_JDO_OPTION_CONNECTION_PASSWORD=password
export HIVE_METASTORE_SERVER=tw-node1204
export SPARK_DRIVER_ADDR=tw-node1204
export EXECUTOR_ID_PATH=/inceptor1/executorID
export METASTORE_ID=metastore_inceptor1


# security environment
cp /etc/inceptor1/conf/krb5.conf /etc
export KRB_ENABLE=true
export EXECUTOR_PRINCIPAL=hive/_HOST@TDH
export EXECUTOR_KEYTAB=/etc/inceptor1/conf/inceptor.keytab
export MASTERPRINCIPAL=hive/tw-node1204
export KEYTAB=/etc/inceptor1/conf/inceptor.keytab
export KRB_PLUGIN_ENABLE=true

