export KIBANA_HOST=${localhostname}

<#if dependencies.SEARCH??>
    <#assign search=dependencies.SEARCH searches=[] searchesWithPort=[]>
    <#list search.roles.SEARCH_SERVER as role>
        <#assign searchesWithPort = [role.hostname + ":" + search[role.id?c]['transport.tcp.port']]>
    </#list>
</#if>
export ELASTICSEARCH_URL=${searchesWithPort[0]}
export KIBANA_PORT=${service['kibana.port']}
<#if service.auth = "kerberos">
cp /etc/${service.sid}/conf/krb5.conf /etc/
</#if>
