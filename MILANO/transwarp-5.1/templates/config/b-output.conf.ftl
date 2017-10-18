<#if dependencies.SEARCH??>
    <#assign search=dependencies.SEARCH searches=[] searchesWithPort=[]>
    <#list search.roles.SEARCH_SERVER as role>
        <#assign searches += [role.hostname]>
        <#assign searchesWithPort += [role.hostname + ":9200"]>
    </#list>
</#if>

output {
  elasticsearch {
    hosts => ["${searchesWithPort?join("\",\"")}"]
    index => "logs-%{+YYYY-MM-dd}"
    template => "/etc/${service.sid}/conf/temp/mappings.txt"
    template_name => "logs"
    template_overwrite => true
    codec => "json"
  }
}
