#!/bin/bash

export TDT_USER=tdt
export LOG_FILE=/var/log/${service.sid}/tdt.log
export EXEC_PATH=/usr/lib/tdt/bin/tdt.sh
export DAEMON_FLAGS=
export PIDFILE=/var/run/tdt/tdt-server.pid
export TDT_CONFIG=/etc/${service.sid}/conf
export TDT_LIB=/usr/lib/tdt/lib
export TDT_LIB_EXT=/usr/lib/tdt/libext

export TDT_JDBC_URL=jdbc：hive2://${dependencies.INCEPTOR.roles.INCEPTOR_SERVER[0]['hostname']}:=${dependencies.INCEPTOR['hive.server2.thrift.port']}/tdt
<#assign hostPorts = []>
<#assign txsql = dependencies['TXSQL']>
<#list txsql.roles['TXSQL_SERVER'] as r>
    <#assign hostPorts = hostPorts + [r.hostname + ':' + txsql['mysql.rw.port']]>
</#list>
export MYSQL_SERVER_PORT=${hostPorts?join(",")}
export JAVAX_JDO_OPTION_CONNECTION_URL=jdbc:mysql://${hostPorts?join(",")}/tdt_${service.sid}
export JAVAX_JDO_OPTION_CONNECTION_USERNAME=${service['tdt.jdbc.user.name']}
export JAVAX_JDO_OPTION_CONNECTION_PASSWORD=${service['tdt.jdbc.password']}
export DATABASE_NAME=tdt_${service.sid}

<#if service.auth = "kerberos">
cp /etc/${service.sid}/conf/krb5.conf /etc/
</#if>