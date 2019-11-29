<#--handle dependent.zookeeper-->
<#if dependencies.ZOOKEEPER??>
    <#assign zookeeper=dependencies.ZOOKEEPER quorums=[]>
    <#list zookeeper.roles.ZOOKEEPER as role>
        <#assign quorums += [role.hostname]>
    </#list>
    <#assign quorum = quorums?join(",")>
</#if>
<#if dependencies.KAFKA??>
    <#assign kafka=dependencies.KAFKA kafkas=[]>
    <#list kafka.roles.KAFKA_SERVER as role>
        <#assign kafkas += [role.hostname + ":" + kafka[role.hostname]["listeners"]?split(":")[2]]>
    </#list>
    <#assign kafka_hosts = kafkas?join(",")>
</#if>
<#--handle dependent.search-->
<#-- TODO modify es port-->
<#if dependencies.SEARCH??>
    <#assign search=dependencies.SEARCH searches=[] searchesWithPort=[]>
    <#list search.roles.SEARCH_SERVER as role>
        <#assign searches += [role.hostname]>
        <#assign searchesWithPort += [role.hostname + ":9200"]>
    </#list>
</#if>
atlas.graph.storage.backend=hbase
atlas.graph.storage.hbase.table=data_catalog_graph

atlas.graph.storage.hostname=${quorum}
atlas.graph.storage.hbase.ext.zookeeper.znode.parent=/${dependencies.HYPERBASE.sid}
atlas.graph.storage.hbase.regions-per-server=1
atlas.graph.storage.lock.wait-time=10000

atlas.EntityAuditRepository.impl=org.apache.atlas.repository.audit.NoopEntityAuditRepository

atlas.graph.index.search.backend=elasticsearch
atlas.graph.index.search.hostname=${searchesWithPort?join(",")}
atlas.graph.index.search.elasticsearch.client-only=true
atlas.graph.index.search.max-result-set-size=1000

atlas.notification.embedded=false
atlas.kafka.zookeeper.connect=${quorum}
atlas.kafka.bootstrap.servers=${kafka_hosts}
atlas.kafka.zookeeper.session.timeout.ms=12000
atlas.kafka.zookeeper.connection.timeout.ms=12000
atlas.kafka.zookeeper.sync.time.ms=3000

#atlas.kafka.enable.auto.commit=true
#atlas.kafka.auto.commit.interval.ms=3000

atlas.kafka.session.timeout.ms=120000
atlas.kafka.poll.timeout.ms=60000
atlas.kafka.max.poll.records=10

atlas.kafka.auto.offset.reset=latest

atlas.kafka.group.id=catalog

atlas.notification.embedded=false
atlas.notification.create.topics=true
atlas.notification.replicas=2
atlas.notification.hook.numthreads=4

atlas.notification.topic.hook=${service['kafka.topic.catalog.hook']}
atlas.notification.topic.entities=${service['kafka.topic.catalog.entities']}

atlas.notification.kafka.service.principal=kafka/${localhostname?lower_case}@${service.realm}
atlas.notification.kafka.keytab.location=/etc/keytabs/keytab

atlas.notification.hook.maxretries=1
atlas.notification.consumer.retry.interval=500

atlas.server.http.port=${service['catalog.platform.http.port']}
atlas.enableTLS=false

atlas.authentication.method.kerberos=<#if service.auth = "kerberos">true<#else>false</#if>
atlas.authentication.method.file=false
atlas.authentication.method.ldap=false

atlas.authentication.method.ldap.type=none

atlas.rest.address=https://localhost:${service['catalog.platform.http.port']}
atlas.server.run.setup.on.start=false
atlas.server.ha.enabled=false

atlas.authorizer.impl=NONE
atlas.authorizer.simple.authz.policy.file=atlas-simple-authz-policy.json

atlas.rest-csrf.enabled=false
atlas.rest-csrf.browser-useragents-regex=^Mozilla.*,^Opera.*,^Chrome.*
atlas.rest-csrf.methods-to-ignore=GET,OPTIONS,HEAD,TRACE
atlas.rest-csrf.custom-header=X-XSRF-HEADER


atlas.search.gremlin.enable=false

<#if service.auth = "kerberos">
atlas.kafka.security.protocol=SASL_PLAINTEXT
atlas.kafka.sasl.mechanism=GSSAPI
atlas.kafka.sasl.kerberos.service.name=kafka
java.security.auth.login.config=/etc/${service.sid}/conf/kafka_client_jaas.conf
</#if>

hyperbase.kerberos.principal=hbase/${localhostname?lower_case}@${service.realm}
hyperbase.kerberos.keytab=${service.keytab}