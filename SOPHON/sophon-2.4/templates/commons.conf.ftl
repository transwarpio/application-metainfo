common.etcd.endpoints=http://${service.roles.SOPHON_ETCD[0].hostname}:2479
cas.service.prefix=https://${dependencies.GUARDIAN.roles.CAS_SERVER[0]['hostname']}:${dependencies.GUARDIAN['cas.server.ssl.port']}/cas

common.redis.host = ${service.roles.SOPHON_REDIS[0].hostname}
common.redis.port = ${service['redis.port']}
common.redis.password = ${service['redis.password']}

sophon.k8s.nfs.dir=/sophon/project

# guardian mode
<#if dependencies.YARN.auth == 'kerberos'>
    sophon.enable.kerberos = true
    sophon.keytab = ${service.keytab}
    sophon.principal = hive/${localhostname?lower_case}@${service.realm}
</#if>