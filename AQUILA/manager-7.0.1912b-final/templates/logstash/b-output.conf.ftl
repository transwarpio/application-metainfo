<#if service.roles.SEARCH_SERVER??>
    <#assign searches=[] searchesWithPort=[]>
    <#list service.roles.SEARCH_SERVER as role>
        <#assign searches += [role.hostname]>
        <#assign searchesWithPort += [role.hostname + ":" + service[role.id?c]['search.http.port']]>
    </#list>
</#if>

output {
  elasticsearch {
    hosts => ["${searchesWithPort?join("\",\"")}"]
    index => "%{[index_prefix]}${service['logstash.index_pattern']}"
    template => "/etc/${service.sid}/conf/temp/mappings.txt"
    template_name => "logs"
    template_overwrite => true
    codec => "json"
  }
}
