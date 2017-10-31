export LOGSTASH_HOST=${localhostname}
export LOGSTASH_PORT=${service['logstash.port']}
export WORKER=${service['logstash.worker_num']}
export BATCH_SIZE=${service['logstash.batch_size']}
export LS_HEAP_SIZE=${service['logstash.heap_size']}

<#if dependencies.SEARCH??>
    <#assign search=dependencies.SEARCH searches=[] searchesWithPort=[]>
    <#list search.roles.SEARCH_SERVER as role>
        <#assign searches += [role.hostname]>
        <#assign searchesWithPort += [role.hostname + ":9200"]>
    </#list>
</#if>
export ES_HOSTS=${searchesWithPort?join(",")}
export ES_PORT=9200

<#if dependencies.KAFKA??>
    <#assign kafka=dependencies.KAFKA kafkas=[]>
    <#list kafka.roles.KAFKA_SERVER as role>
        <#assign kafkas += [role.hostname + ":" + kafka[role.hostname]["listeners"]?split(":")[2]]>
    </#list>
</#if>
export KAFKA_HOSTS=${kafkas?join(",")}
export KAFKA_PORT=9092

<#if service.auth = "kerberos">
export KRB_ENABLE=true
export KRB_REALM=${service.realm}
export LG_PRINCIPAL=kafka/${localhostname}@${service.realm}
export LG_KEYTAB=/etc/${service.sid}/conf/milano.keytab
cp /etc/${service.sid}/conf/krb5.conf /etc/
<#else>
export KRB_ENABLE=false
</#if>

