#!/bin/bash
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License. See accompanying LICENSE file.
#
set -x
# Set kms specific environment variables here.

# Settings for the Embedded Tomcat that runs KMS
# Java System properties for KMS should be specified in this variable
#
# export CATALINA_OPTS=

# KMS logs directory
#
# export KMS_LOG=

# KMS temporary directory
#
# export KMS_TEMP=

# The HTTP port used by KMS
#
# export KMS_HTTP_PORT=16000

# The Admin port used by KMS
#
# export KMS_ADMIN_PORT=

# The maximum number of Tomcat handler threads
#
# export KMS_MAX_THREADS=1000

# The location of the SSL keystore if using SSL
#
# export KMS_SSL_KEYSTORE_FILE=

# The password of the SSL keystore if using SSL
#
# export KMS_SSL_KEYSTORE_PASS=password

# The full path to any native libraries that need to be loaded
# (For eg. location of natively compiled tomcat Apache portable
# runtime (APR) libraries
#
# export JAVA_LIBRARY_PATH=

export CATALINA_PID=/var/run/hadoop-kms/hadoop-kms-kms.pid
export KMS_LOG=/var/log/${service.sid}
export KMS_TEMP=$KMS_LOG

export KMS_HTTP_PORT=${service['kms.http.port']}
export KMS_ADMIN_PORT=${service['kms.admin.port']}

export KMS_SSL_KEYSTORE_FILE=$HOME/.keystore
export KMS_SSL_KEYSTORE_PASS=password

<#assign mysqlHostPorts = []/>
<#list dependencies.TXSQL.roles['TXSQL_SERVER'] as role>
    <#assign mysqlHostPorts = mysqlHostPorts + [role.hostname + ':' + dependencies.TXSQL['mysql.rw.port']]>
</#list>
<#assign mysqlHostPort = mysqlHostPorts?join(",")>
export JAVAX_JDO_OPTION_CONNECTION_URL=jdbc:mysql://${mysqlHostPort}/kms_${service.sid}
export JAVAX_JDO_OPTION_CONNECTION_USERNAME=${service['javax.jdo.option.ConnectionUserName']}
export JAVAX_JDO_OPTION_CONNECTION_PASSWORD=${service['javax.jdo.option.ConnectionPassword']}

<#if service.auth = "kerberos">
cp /etc/${service.sid}/conf/krb5.conf /etc/
</#if>
