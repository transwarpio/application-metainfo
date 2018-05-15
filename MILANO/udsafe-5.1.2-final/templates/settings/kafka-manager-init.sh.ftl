nc_until_ready() {
  for ((i = 0; i < $4; i++)); do
    nc $1 $2 -w $3 && return 0
    echo "$1 is not ready, wait for $3 seconds ..."
    sleep $3
  done
  return 1
}

<#if dependencies.ZOOKEEPER??>
    <#assign zookeeper=dependencies.ZOOKEEPER quorums=[]>
    <#list zookeeper.roles.ZOOKEEPER as role>
        <#assign quorums += [role.hostname + ":" + zookeeper["zookeeper.client.port"]]>
    </#list>
    <#assign quorum = quorums?join(",")>
</#if>

nc_until_ready ${localhostname} ${service['kafka.manager.port']} 5 240

curl -XPOST ${localhostname}:${service['kafka.manager.port']}/clusters --data 'name=tdh&zkHosts=${quorum}&kafkaVersion=0.10.2.1'
