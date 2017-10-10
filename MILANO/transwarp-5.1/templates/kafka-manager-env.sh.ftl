<#if dependencies.ZOOKEEPER??>
    <#assign zookeeper=dependencies.ZOOKEEPER quorums=[]>
    <#list zookeeper.roles.ZOOKEEPER as role>
        <#assign quorums += [role.hostname + ":" + zookeeper[role.hostname]["zookeeper.client.port"]]>
    </#list>
    <#assign quorum = quorums?join(",")>
</#if>
export TRANSWARP_ZOOKEEPER_QUORUM=${quorum}

<#if dependencies.KAFKA??>
    <#assign kafka=dependencies.KAFKA kafkas=[]>
    <#list kafka.roles.KAFKA_SERVER as role>
        <#assign kafkas += [role.hostname + ":" + kafka[role.hostname]["listeners"]?split(":")[2]]>
    </#list>
</#if>
export KAFKA_HOSTS=${kafkas?join(",")}
export KF_MGR_PORT=${service['kafka.manager.port']}

<#if service.auth = "kerberos">
export KRB_ENABLE=true
export KRB_OPTS="-Djava.security.krb5.conf=/etc/${service.sid}/conf/krb5.conf -Djava.security.auth.login.config=/etc/${service.sid}/conf/kafka-manager-jaas.conf"
<#else>
export KRB_ENABLE=false
</#if>

