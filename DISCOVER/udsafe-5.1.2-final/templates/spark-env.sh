#!/usr/bin/env bash
#
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

export SPARK_CLIENT_MEM="-Xmx${service['spark.client.memory']}m"
export SPARK_LAUNCH_WITH_SCALA=0
export SPARK_LIBRARY_PATH=$SPARK_HOME/lib
export SCALA_LIBRARY_PATH=$SPARK_HOME/lib
export SPARK_MASTER_WEBUI_PORT=${service['spark.master.webui.port']}
export SPARK_WORKER_WEBUI_PORT=${service['spark.worker.webui.port']}
export SPARK_MASTER_PORT=${service['spark.master.port']}
export SPARK_WORKER_PORT=${service['spark.worker.port']}
export SPARK_WORKER_DIR=/var/run/spark/work
export SPARK_LOG_DIR=/var/log/${service.sid}
export SPARK_HISTORY_OPTS="$SPARK_HISTORY_OPTS -Dspark.history.fs.logDirectory=hdfs:///var/log/spark/apps -Dspark.history.ui.port=${service['spark.history.ui.port']}"

export HADOOP_CONF_DIR=/etc/${dependencies.YARN.sid}/conf

### Comment above 2 lines and uncomment the following if
### you want to run with scala version, that is included with the package
#export SCALA_HOME=$SCALA_HOME:-/usr/lib/discover/scala
#export PATH=$PATH:$SCALA_HOME/bin
### change the following to specify a real cluster's Master host
export STANDALONE_SPARK_MASTER_HOST=`hostname`
