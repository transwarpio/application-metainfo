#
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
#

# Set Sqoop specific environment variables here

<#if service['sqoop.container.limits.memory'] != "-1" && service['sqoop.memory.ratio'] != "-1">
  <#assign limitsMemory = service['sqoop.container.limits.memory']?number
    memoryRatio = service['sqoop.memory.ratio']?number
    memory = limitsMemory * memoryRatio * 1024>
<#else>
  <#assign memory = service['sqoop.server.memory']?number>
</#if>
JAVA_OPTS="$JAVA_OPTS -Xmx${memory?floor}m -Dsqoop.config.dir=/etc/${service.sid}/conf"

# The port Sqoop server runs
#
export SQOOP_HTTP_PORT=${service['sqoop.http.port']}

# Sqoop Admin port
export SQOOP_ADMIN_PORT=${service['sqoop.admin.port']}

export SQOOP_LOG_DIR=/var/log/${service.sid}

export CATALINA_TMPDIR=/var/transwarp/data/server/temp

export YARN_LOG_DIR=/var/log/${dependencies.YARN.sid}

export USER=yarn
