<#assign
  registryServer=dependencies.REGISTRY.roles['REGISTRY_SERVER'][0].hostname
  registryPort=dependencies.REGISTRY['registry.port']
  servers=service.roles.GUARDIAN_SERVER?sort_by("id")
  master=servers[0].hostname
>
apacheds-backend-master:
  image: ${registryServer}:${registryPort}/transwarp/apacheds:tdh500
  net: host
  working_dir: /usr/lib/guardian-apacheds/scripts
  volumes:
    - /etc/${service.sid}/conf/:/etc/guardian-apacheds/conf/persistent
    - ${service['guardian.apacheds.data.dir']}:/var/lib/guardian-apacheds/data
  command: ./bootstrap.sh
  environment:
    - GUARDIAN_DS_DOMAIN=${service['guardian.ds.domain']}
    - GUARDIAN_DS_LDAP_PORT=${service['guardian.apacheds.ldap.port']}
    - GUARDIAN_DS_REALM=${service['guardian.ds.realm']}
    - GUARDIAN_DS_KDC_PORT=${service['guardian.apacheds.kdc.port']}
    - GUARDIAN_DS_PARTITION_SYNC_ON_WRITE=false
    - GUARDIAN_DS_ADMIN_PASSWORD=${service['guardian.admin.password']} #only valid when the first time ds starts
    - GUARDIAN_DS_ROOT_PASSWORD=${service['guardian.ds.root.password']} #only valid when the first time ds starts
    <#if (servers?size > 1)>
    - GUARDIAN_DS_HA_ENABLED=true
    - GUARDIAN_DS_HA_STATUS=${(master == localhostname)?then("master", "slave")}
    <#else>
    - GUARDIAN_DS_HA_ENABLED=false
    </#if>
    <#if master != localhostname>
    - GUARDIAN_DS_HA_MASTER_HOST=${master}
    - GUARDIAN_DS_HA_MASTER_PORT=${service['guardian.apacheds.ldap.port']}
    </#if>
  restart: always

<#if (servers?size >1)>
  <#assign slaves=servers[1..(servers?size-1)] slaves_with_port=[]>
  <#list slaves as slave>
    <#assign slaves_with_port += [slave.hostname + ":" + service['guardian.apacheds.ldap.port']]>
  </#list>
</#if>
guardian-server:
  image: ${registryServer}:${registryPort}/transwarp/guardian:tdh500
  net: host
  working_dir: /usr/lib/guardian/scripts
  volumes:
    - /etc/${service.sid}/conf/:/etc/guardian/conf/persistent
  command: ["./wait-for-it.sh", "${master}:${service['guardian.apacheds.ldap.port']}", "--", "./bootstrap.sh"]
  environment:
    - GUARDIAN_SERVER_BIND_PORT=${service['guardian.server.port']}
    - LDAP_HOST=${master}
    - LDAP_PORT=${service['guardian.apacheds.ldap.port']}
    - GUARDIAN_CONNECTION_PASSWORD=${service['guardian.admin.password']}
    - BIND_PWD=${service['guardian.ds.root.password']}
    <#if (servers?size > 1)>
    - LDAP_SLAVES=${slaves_with_port?join(";")}
    </#if>
  restart: always