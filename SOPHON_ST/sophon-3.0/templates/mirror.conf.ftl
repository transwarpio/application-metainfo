<#if dependencies.SEARCH??>
  <#assign search=dependencies.SEARCH searches=[] port=[]>
  <#list search.roles.SEARCH_SERVER as role>
    <#assign searches += [role.hostname]>
    <#assign port += [search[role.id?c]['http.port']]>
  </#list>
</#if>
#ES properties
mirror.eshost = ${searches[0]}
mirror.esport = ${port[0]}

#HDFS properties
hdfs.main.username=hdfs

#Distribute data base
DDB=${service['distributed.database.type']}

#inceptor properties
inceptor.host=${dependencies.INCEPTOR.roles.INCEPTOR_SERVER[0]['hostname']}
inceptor.port=${dependencies.INCEPTOR['hive.server2.thrift.port']}
inceptor.principal=hive/${dependencies.INCEPTOR.roles.INCEPTOR_SERVER[0]['hostname']}@${service.realm}
inceptor.kuser=hive/${localhostname?lower_case}@${service.realm}
inceptor.kerberos=${dependencies.INCEPTOR.auth}
inceptor.authentication=${dependencies.INCEPTOR['hive.server2.authentication']}
inceptor.ldap.username=${service['inceptor.ldap.username']}
inceptor.ldap.password=${service['inceptor.ldap.password']}
inceptor.hiveserver2=true
inceptor.database.prod=default
inceptor.keytab=${service.keytab}
inceptor.pool.size=64
inceptor.pool.timeout=3600
inceptor.label.numbuckets=30
inceptor.check.samples=100
inceptor.estable.numshards=10

mirror.superuser.username=${service['superuser.username']}
mirror.superuser.password=${service['superuser.password']}

spark.sql.warehouse.dir=${service['spark.sql.warehouse.dir']}
spark.master=yarn-client
spark.yarn.appMasterEnv.JAVA_HOME=/usr/java/jdk1.8.0_25
spark.executorEnv.JAVA_HOME=/usr/java/jdk1.8.0_25
spark.executor.instances=${service['spark.executor.num']}
spark.executor.cores=${service['spark.executor.core']}
spark.yarn.keytab=${service.keytab}
spark.yarn.principal=hive/${localhostname?lower_case}@${service.realm}
enable.livy=${service['enable.livy']}

mirror.host=${service.roles.SOPHON_ST_BACKEND[0]['hostname']}
task.pool.size=${service['task.pool.size']}
task.max.concurrency=${service['task.max.concurrency']}
task.timeout=${service['task.timeout']}
mirror.keytab=${service.keytab}
mirror.principal=hive/${localhostname?lower_case}@${service.realm}
<#if dependencies.GUARDIAN??>
  <#if dependencies.GUARDIAN.roles.CAS_SERVER??>
cas.service.prefix=https://${dependencies.GUARDIAN.roles.CAS_SERVER[0]['hostname']}:${dependencies.GUARDIAN['cas.server.ssl.port']}${dependencies.GUARDIAN['cas.server.context.path']}
  </#if>
</#if>
disable.cas.authorization=${service['disable.cas.authorization']}

workflow.domain.id=0
<#assign workflowHostPorts = []/>
<#list dependencies.WORKFLOW.roles['WORKFLOW_SERVER'] as role>
<#assign workflowHostPorts = workflowHostPorts + [role.hostname + ':' + dependencies.WORKFLOW['workflow.http.port']]>
</#list>
<#assign workflowHostPort = workflowHostPorts?join(",")>
# the workflow service location
workflow.service.scheme=http
workflow.service.host=${workflowHostPort}
workflow.service.path=/api/v1/
# the path of login module
workflow.service.login=login
# connect timeout in milliseconds
workflow.connect.timeout=5000000
# socket timeout in milliseconds
workflow.socket.timeout=5000000
workflow.client.username=${service['workflow.client.username']}
workflow.client.password=${service['workflow.client.password']}
workflow.client.token=${service['workflow.client.token']}
