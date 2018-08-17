<#if service['kafka.rest.memory']??>
  export KAFKAREST_HEAP_OPTS="-Xmx${service['kafka.rest.memory']}M"
</#if>
