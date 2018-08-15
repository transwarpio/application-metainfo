#!/usr/bin/env bash

export LOG_DIR=/var/log/${service.sid}
export LOCAL_HOST=${localhostname}
<#list service.roles["GUARDIAN_TXSQL_SERVER"] as r>
    <#if r.id == .data_model['role.id']>
export LOCAL_IP=${r.ip}
        <#break>
    </#if>
</#list>
export SQL_RW_PORT=${service['mysql.rw.port']}
