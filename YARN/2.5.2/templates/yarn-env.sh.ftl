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

# User for YARN daemons
export HADOOP_YARN_USER=${r"${HADOOP_YARN_USER:-yarn}"}

# resolve links - $0 may be a softlink
export YARN_LOG_DIR=/var/log/${service.sid}
export HDFS_CONF_DIR=/etc/${dependencies.HDFS.sid}/conf
export YARN_RESOURCEMANAGER_ADDRRESS=${service.roles.YARN_RESOURCEMANAGER[0]['hostname']}
export NODEMANAGER_LOCAL_DIRS=${service['yarn.nodemanager.local-dirs']}
export NODEMANAGER_LOG_DIRS=${service['yarn.nodemanager.log-dirs']}
<#if service.roles.YARN_TIMELINESERVER??>
export YARN_TIMELINE_SERVICE_HOSTNAME=${service.roles.YARN_TIMELINESERVER[0]['hostname']}
</#if>


# some Java parameters
# export JAVA_HOME=/home/y/libexec/jdk1.6.0/
if [ "$JAVA_HOME" != "" ]; then
  #echo "run java in $JAVA_HOME"
  JAVA_HOME=$JAVA_HOME
fi

if [ "$JAVA_HOME" = "" ]; then
  echo "Error: JAVA_HOME is not set."
  exit 1
fi

JAVA=$JAVA_HOME/bin/java
JAVA_HEAP_MAX=-Xmx4096m

# Specify the heap memory setting for yarn roles which will overwrite the JAVA_HEAP_MAX setting
<#if service[.data_model["localhostname"]]['nodemanager.memory']??>
<#assign YARN_NODEMANAGER_HEAPSIZE=service[.data_model["localhostname"]]['nodemanager.memory']?trim>
<#else>
<#assign YARN_NODEMANAGER_HEAPSIZE=4096>
</#if>
<#if service[.data_model["localhostname"]]['resourcemanager.memory']??>
<#assign YARN_RESOURCEMANAGER_HEAPSIZE=service[.data_model["localhostname"]]['resourcemanager.memory']>
<#else>
<#assign YARN_RESOURCEMANAGER_HEAPSIZE=4096>
</#if>
<#if service[.data_model["localhostname"]]['historyserver.memory']??>
<#assign YARN_HISTORYSERVER_HEAPSIZE=service[.data_model["localhostname"]]['historyserver.memory']>
<#else>
<#assign YARN_HISTORYSERVER_HEAPSIZE=4096>
</#if>
<#if service[.data_model["localhostname"]]['timelineserver.memory']??>
<#assign YARN_TIMELINESERVER_HEAPSIZE=service[.data_model["localhostname"]]['timelineserver.memory']>
<#else>
<#assign YARN_TIMELINESERVER_HEAPSIZE=4096>
</#if>
export YARN_NODEMANAGER_HEAPSIZE=${YARN_NODEMANAGER_HEAPSIZE}m
export YARN_RESOURCEMANAGER_HEAPSIZE=${YARN_RESOURCEMANAGER_HEAPSIZE}m
export YARN_HISTORYSERVER_HEAPSIZE=${YARN_HISTORYSERVER_HEAPSIZE}m
export YARN_TIMELINESERVER_HEAPSIZE=${YARN_TIMELINESERVER_HEAPSIZE}m

# check envvars which might override default args
if [ "$YARN_HEAPSIZE" != "" ]; then
  #echo "run with heapsize $YARN_HEAPSIZE"
  JAVA_HEAP_MAX="-Xmx""$YARN_HEAPSIZE""m"
  #echo $JAVA_HEAP_MAX
fi

# so that filenames w/ spaces are handled correctly in loops below
IFS=


# default log directory & file
if [ "$YARN_LOG_DIR" = "" ]; then
  YARN_LOG_DIR="$YARN_HOME/logs"
fi
if [ "$YARN_LOGFILE" = "" ]; then
  YARN_LOGFILE='yarn.log'
fi

# default policy file for service-level authorization
if [ "$YARN_POLICYFILE" = "" ]; then
  YARN_POLICYFILE="hadoop-policy.xml"
fi

# restore ordinary behaviour
unset IFS

<#if service.auth = "kerberos">
cp /etc/${service.sid}/conf/krb5.conf /etc
</#if>
