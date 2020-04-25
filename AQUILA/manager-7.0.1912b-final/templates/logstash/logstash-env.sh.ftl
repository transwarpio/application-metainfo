export LOGSTASH_HOST=${localhostname}
export LOGSTASH_PORT=${service['logstash.port']}
export WORKER=${service['logstash.worker_num']}
export BATCH_SIZE=${service['logstash.batch_size']}
export LS_HEAP_SIZE=${service['logstash.heap_size']}

<#if service.roles.SEARCH_SERVER??>
    <#assign searches=[] searchesWithPort=[]>
    <#list service.roles.SEARCH_SERVER as role>
        <#assign searches += [role.hostname]>
        <#assign searchesWithPort += [role.hostname + ":" + service[role.id?c]['search.http.port']]>
    </#list>
</#if>
export ES_HOSTS=${searchesWithPort?join(",")}
export ES_PORT=${service[service.roles.SEARCH_SERVER[0].id?c]['search.http.port']}

<#if service.roles.KAFKA_SERVER??>
    <#assign kafkas=[]>
    <#list service.roles.KAFKA_SERVER as role>
        <#assign kafkas += [role.hostname + ":" + service[role.hostname]["kafka.listeners"]?split(":")[2]]>
    </#list>
</#if>
export KAFKA_HOSTS=${kafkas?join(",")}
export KAFKA_PORT=19092

<#if service.auth = "kerberos">
export KRB_ENABLE=true
export KRB_REALM=${service.realm}
export LG_PRINCIPAL=kafka/${localhostname}@${service.realm}
export LG_KEYTAB=/etc/${service.sid}/conf/aquila.keytab
cp /etc/${service.sid}/conf/krb5.conf /etc/
<#else>
export KRB_ENABLE=false
</#if>

