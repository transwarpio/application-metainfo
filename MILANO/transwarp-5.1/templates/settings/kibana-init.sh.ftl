<#if dependencies.SEARCH??>
    <#assign search=dependencies.SEARCH searches=[] searchesWithPort=[]>
    <#list search.roles.SEARCH_SERVER as role>
        <#assign search = [role.hostname]>
        <#assign searchWithPort = [role.hostname + ":9200"]>
    </#list>
</#if>

ELASTICSEARCH_URL=${searchWithPort[0]}

set +e
o=`curl $ELASTICSEARCH_URL/.kibana 2>/dev/null | grep '"status":404'`
set -e
if [ "$o" != "" ]; then
curl -XPUT $ELASTICSEARCH_URL/.kibana -d @/etc/${service.sid}/settings/kibana-index.json
fi
curl -s -H "Content-Type: application/x-ndjson" -XPOST $ELASTICSEARCH_URL/_bulk --data-binary @/etc/${service.sid}/settings/kibana-demo.json
