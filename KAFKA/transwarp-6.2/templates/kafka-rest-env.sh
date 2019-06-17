#!/usr/bin/env bash
<#if service['kafka.rest.memory']??>
export KAFKAREST_HEAP_OPTS="-Xmx${service['kafka.rest.memory']}M"
</#if>

<#if service.auth == "kerberos">
export KAFKAREST_HEAP_OPTS=$KAFKAREST_HEAP_OPTS" -Djava.security.krb5.conf=/etc/${service.sid}/conf/krb5.conf -Dzookeeper.sasl.clientconfig=/etc/${service.sid}/conf/jaas.conf -Djava.security.auth.login.config=/etc/${service.sid}/conf/jaas.conf"
</#if>

