<#compress>
dataDir=/var/${service.sid}/
clientPort=${service['zookeeper.client.port']}

<#--Generate all server properties-->
<#assign roles=service['roles']['ZOOKEEPER'] size=roles?size>
<#list 1..size as n>
    <#assign role=roles[n_index]
    commu_port=service['zookeeper.peer.communicate.port']
    elect_port=service['zookeeper.leader.elect.port']>
    server.${role.id}=${role.hostname}:${commu_port}:${elect_port}
</#list>

<#--The following properties only appear when enable kerberos-->
<#if service.auth == "kerberos">
    authProvider.1=org.apache.zookeeper.server.auth.SASLAuthenticationProvider
    jaasLoginRenew=3600000
    kerberos.removeHostFromPrincipal=true
    kerberos.removeRealmFromPrincipal=true
<#else>
    skipACL=yes
</#if>

<#--Take properties from the context-->
<#list service['zoo_cfg']?keys as key>
    ${key}=${service['zoo_cfg'][key]}
</#list>

autopurge.purgeInterval=1
autopurge.snapRetainCount=10
</#compress>
