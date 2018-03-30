#!/usr/bin/env bash
#
# Licensed to Cloudera, Inc. under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  Cloudera, Inc. licenses this file
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
#
# LIVY ENVIRONMENT VARIABLES
#
# - JAVA_HOME       Java runtime to use. By default use "java" from PATH.
# - HADOOP_CONF_DIR Directory containing the Hadoop / YARN configuration to use.
# - SPARK_HOME      Spark which you would like to use in Midas.
# - SPARK_CONF_DIR  Optional directory where the Spark configuration lives.
#                   (Default: $SPARK_HOME/conf)
# - MIDAS_SERVER_JAVA_OPTS  Java Opts for running midas server (You can set jvm related setting here,
#                          like jvm memory/gc algorithm and etc.)

SPARK_HOME=/usr/lib/spark2
SPARK_USER=hive
HADOOP_USER_NAME=hive
MIDAS_SERVER_JAVA_OPTS="-Xms512m -Xmx1024m -XX:PermSize=128m"
HADOOP_CONF_DIR=/etc/yarn1/conf
LIVY_LOG_DIR=/var/log/midas
DIEU_HOME=/usr/lib/sophon
DIEU_CONF_DIR=/etc/${service.sid}/conf
# for Jupyter notebook running on server
unset XDG_RUNTIME_DIR
<#if service.auth = "kerberos">
cp /etc/${service.sid}/conf/krb5.conf /etc/
</#if>
