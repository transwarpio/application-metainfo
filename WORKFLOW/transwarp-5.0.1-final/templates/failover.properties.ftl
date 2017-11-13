# the general control of enabling/disabling failover
<#if service.roles.WORKFLOW_SERVER?size gt 1>
failover.enabled=true
<#else>
failover.enabled=false
</#if>

# the master port of workflow service
master.port=${service['workflow.http.port']}

# the zookeeper quorum used for failover
#zk.quorum=127.0.0.1:2181

# use manager template engine to pass zookeeper quorum information

<#--handle dependent.zookeeper-->
<#if dependencies.ZOOKEEPER??>
    <#assign zookeeper=dependencies.ZOOKEEPER quorums=[]>
    <#list zookeeper.roles.ZOOKEEPER as role>
        <#assign quorums += [role.hostname + ":" + zookeeper[role.hostname]["zookeeper.client.port"]]>
    </#list>
    <#assign quorum = quorums?join(",")>
</#if>
zk.quorum=${quorum}
zk.session.timeout.millis=180000
znode.base=${service.sid}
znode.master=master
znode.backup.master=backup-master
znode.election=election
