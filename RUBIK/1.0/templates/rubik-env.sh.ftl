#!/bin/bash

export MAXMEMSIZE=${service['max.memory.size']}m

export LOG_DIR=/var/log/${service.sid}
export RUBIK_CONF_DIR=/etc/${service.sid}/conf

<#assign hostPorts = []>
<#assign txsql = dependencies['TXSQL']>
<#list txsql.roles['TXSQL_SERVER'] as r>
    <#assign hostPorts = hostPorts + [r.hostname + ':' + txsql['mysql.rw.port']]>
</#list>
export MYSQL_SERVER_PORT=${hostPorts?join(",")}
export JAVAX_JDO_OPTION_CONNECTION_URL=jdbc:mysql://${hostPorts?join(",")}/rubik_${service.sid}
export JAVAX_JDO_OPTION_CONNECTION_USERNAME=${service['javax.jdo.option.ConnectionUserName']}
export JAVAX_JDO_OPTION_CONNECTION_PASSWORD=${service['javax.jdo.option.ConnectionPassword']}
export DATABASE_NAME=rubik_${service.sid}
