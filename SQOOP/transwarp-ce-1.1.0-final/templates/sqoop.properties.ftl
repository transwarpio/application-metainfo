<#noparse>
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

#
# Sqoop configuration file used by the built in configuration
# provider: org.apache.sqoop.core.PropertiesConfigurationProvider.
# This file must reside in the system configuration directory
# which is specified by the system property "sqoop.config.dir"
# and must be called sqoop.properties.
#
# NOTE: Tokens specified in this file that are marked by a
# leading and trailing '@' characters should be replaced by
# their appropriate values. For example, the token /var/log/sqoop2
# should be replaced  appropriately.
#
# The following tokens are used in this configuration file:
#
# LOGDIR
#   The absolute path to the directory where system genearated
#   log files will be kept.
#
# BASEDIR
#   The absolute path to the directory where Sqoop 2 is installed
#

#
# Logging Configuration
# Any property that starts with the prefix
# org.apache.sqoop.log4j is parsed out by the configuration
# system and passed to the log4j subsystem. This allows you
# to specify log4j configuration properties from within the
# Sqoop configuration.
#
org.apache.sqoop.log4j.appender.file=org.apache.log4j.RollingFileAppender
</#noparse>
org.apache.sqoop.log4j.appender.file.File=/var/log/${service.sid}/sqoop.log
<#noparse>
org.apache.sqoop.log4j.appender.file.MaxFileSize=25MB
org.apache.sqoop.log4j.appender.file.MaxBackupIndex=5
org.apache.sqoop.log4j.appender.file.layout=org.apache.log4j.PatternLayout
org.apache.sqoop.log4j.appender.file.layout.ConversionPattern=%d{ISO8601} %-5p %c{2} [%l] %m%n
org.apache.sqoop.log4j.debug=true
org.apache.sqoop.log4j.rootCategory=WARN, file
org.apache.sqoop.log4j.category.org.apache.sqoop=DEBUG
org.apache.sqoop.log4j.category.org.apache.derby=INFO

#
# Audit Loggers Configuration
# Multiple audit loggers could be given here. To specify an
# audit logger, you should at least add org.apache.sqoop.
# auditlogger.[LoggerName].class. You could also provide
# more configuration options by using org.apache.sqoop.
# auditlogger.[LoggerName] prefix, then all these options
# are parsed to the logger class.
#
</#noparse>
org.apache.sqoop.auditlogger.default.class=org.apache.sqoop.audit.FileAuditLogger
org.apache.sqoop.auditlogger.default.file=/var/log/${service.sid}/default.audit
<#noparse>
#
# Repository configuration
# The Repository subsystem provides the special prefix which
# is "org.apache.sqoop.repository.sysprop". Any property that
# is specified with this prefix is parsed out and set as a
# system property. For example, if the built in Derby repository
# is being used, the sysprop prefixed properties can be used
# to affect Derby configuration at startup time by setting
# the appropriate system properties.
#

# Repository provider
org.apache.sqoop.repository.provider=org.apache.sqoop.repository.JdbcRepositoryProvider
org.apache.sqoop.repository.schema.immutable=false

# JDBC repository provider configuration
org.apache.sqoop.repository.jdbc.handler=org.apache.sqoop.repository.derby.DerbyRepositoryHandler
org.apache.sqoop.repository.jdbc.transaction.isolation=READ_COMMITTED
org.apache.sqoop.repository.jdbc.maximum.connections=10
org.apache.sqoop.repository.jdbc.url=jdbc:derby:/var/transwarp/data/repository/db;create=true
org.apache.sqoop.repository.jdbc.driver=org.apache.derby.jdbc.EmbeddedDriver
org.apache.sqoop.repository.jdbc.user=sa
org.apache.sqoop.repository.jdbc.password=
</#noparse>
# System properties for embedded Derby configuration
org.apache.sqoop.repository.sysprop.derby.stream.error.file=/var/log/${service.sid}/derbyrepo.log

<#noparse>
#
# Connector configuration
#
org.apache.sqoop.connector.autoupgrade=false

#
# Framework configuration
#
org.apache.sqoop.framework.autoupgrade=false

# Sleeping period for reloading configuration file (once a minute)
org.apache.sqoop.core.configuration.provider.properties.sleep=60000

#
# Submission engine configuration
#

# Submission engine class
org.apache.sqoop.submission.engine=org.apache.sqoop.submission.mapreduce.MapreduceSubmissionEngine

# Number of milliseconds, submissions created before this limit will be removed, default is one day
#org.apache.sqoop.submission.purge.threshold=

# Number of milliseconds for purge thread to sleep, by default one day
#org.apache.sqoop.submission.purge.sleep=

# Number of milliseconds for update thread to sleep, by default 5 minutes
#org.apache.sqoop.submission.update.sleep=

#
# Configuration for Mapreduce submission engine (applicable if it's configured)
#
</#noparse>

# Hadoop configuration directory
org.apache.sqoop.submission.engine.mapreduce.configuration.directory=/etc/${dependencies.YARN.sid}/conf/

#
# Execution engine configuration
#
org.apache.sqoop.execution.engine=org.apache.sqoop.execution.mapreduce.MapreduceExecutionEngine

#
# Authentication configuration
#
<#if service.auth = "kerberos">
org.apache.sqoop.authentication.type=KERBEROS
org.apache.sqoop.authentication.handler=org.apache.sqoop.security.KerberosAuthenticationHandler
org.apache.sqoop.authentication.kerberos.principal=sqoop2/${localhostname?lower_case}@${service.realm}
org.apache.sqoop.authentication.kerberos.keytab=${service.keytab}
org.apache.sqoop.authentication.kerberos.http.principal=HTTP/${localhostname?lower_case}@${service.realm}
org.apache.sqoop.authentication.kerberos.http.keytab=${service.keytab}
<#else>
org.apache.sqoop.authentication.type=SIMPLE
org.apache.sqoop.authentication.handler=org.apache.sqoop.security.SimpleAuthenticationHandler
</#if>
