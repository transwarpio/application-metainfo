#
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

#########  Graph Database Configs  #########

# Graph Database

#Configures the graph database to use.  Defaults to JanusGraph
#atlas.graphdb.backend=org.apache.atlas.repository.graphdb.janus.AtlasJanusGraphDatabase

# Graph Storage
# Set atlas.graph.storage.backend to the correct value for your desired storage
# backend. Possible values:
#
# hbase
# cassandra
# embeddedcassandra - Should only be set by building Atlas with  -Pdist,embedded-cassandra-solr
# berkeleyje
#
# See the configuration documentation for more information about configuring the various  storage backends.
#

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

#Hbase
#For standalone mode , specify localhost
#for distributed mode, specify zookeeper quorum here
#atlas.graph.storage.hostname=localhost
atlas.graph.storage.hostname=${quorum}
atlas.graph.storage.hbase.ext.zookeeper.znode.parent=/${dependencies.HYPERBASE.sid}
atlas.graph.storage.hbase.regions-per-server=1
atlas.graph.storage.lock.wait-time=10000

#In order to use Cassandra as a backend, comment out the hbase specific properties above, and uncomment the
#the following properties
#atlas.graph.storage.clustername=
#atlas.graph.storage.port=

# Gremlin Query Optimizer
#
# Enables rewriting gremlin queries to maximize performance. This flag is provided as
# a possible way to work around any defects that are found in the optimizer until they
# are resolved.
#atlas.query.gremlinOptimizerEnabled=true

# Delete handler
#
# This allows the default behavior of doing "soft" deletes to be changed.
#
# Allowed Values:
# org.apache.atlas.repository.store.graph.v1.SoftDeleteHandlerV1 - all deletes are "soft" deletes
# org.apache.atlas.repository.store.graph.v1.HardDeleteHandlerV1 - all deletes are "hard" deletes
#
#atlas.DeleteHandlerV1.impl=org.apache.atlas.repository.store.graph.v1.SoftDeleteHandlerV1

# Entity audit repository
#
# This allows the default behavior of logging entity changes to hbase to be changed.
#
# Allowed Values:
# org.apache.atlas.repository.audit.HBaseBasedAuditRepository - log entity changes to hbase
# org.apache.atlas.repository.audit.CassandraBasedAuditRepository - log entity changes to cassandra
# org.apache.atlas.repository.audit.NoopEntityAuditRepository - disable the audit repository
#
atlas.EntityAuditRepository.impl=org.apache.atlas.repository.audit.NoopEntityAuditRepository

# if Cassandra is used as a backend for audit from the above property, uncomment and set the following
# properties appropriately. If using the embedded cassandra profile, these properties can remain
# commented out.
# atlas.EntityAuditRepository.keyspace=atlas_audit
# atlas.EntityAuditRepository.replicationFactor=1


# Graph Search Index
#atlas.graph.index.search.backend=solr
atlas.graph.index.search.backend=elasticsearch

#Solr
#Solr cloud mode properties
#atlas.graph.index.search.solr.mode=cloud
#atlas.graph.index.search.solr.zookeeper-url=
#atlas.graph.index.search.solr.zookeeper-connect-timeout=60000
#atlas.graph.index.search.solr.zookeeper-session-timeout=60000
#atlas.graph.index.search.solr.wait-searcher=true

#Solr http mode properties
#atlas.graph.index.search.solr.mode=http
#atlas.graph.index.search.solr.http-urls=http://localhost:8983/solr

# ElasticSearch support (Tech Preview)
# Comment out above solr configuration, and uncomment the following two lines. Additionally, make sure the
# hostname field is set to a comma delimited set of elasticsearch master nodes, or an ELB that fronts the masters.
#
# Elasticsearch does not provide authentication out of the box, but does provide an option with the X-Pack product
# https://www.elastic.co/products/x-pack/security
#
# Alternatively, the JanusGraph documentation provides some tips on how to secure Elasticsearch without additional
# plugins: http://docs.janusgraph.org/latest/elasticsearch.html
#atlas.graph.index.hostname=localhost
atlas.graph.index.search.hostname=${searchesWithPort?join(",")}
atlas.graph.index.search.elasticsearch.client-only=true
#atlas.graph.index.search.index-name={{ getenv "ES_INDEX_NAME" "data-catalog"}}
#atlas.graph.index.search.elasticsearch.cluster-name=${dependencies.SEARCH['cluster.name']}
#atlas.graph.index.search.elasticsearch.local-mode=true
#atlas.graph.index.search.elasticsearch.create.sleep=2000
#atlas.graph.index.search.elasticsearch.rest.address=${searchesWithPort?join(",")}

# Solr-specific configuration property
atlas.graph.index.search.max-result-set-size=1000

#########  Notification Configs  #########
#atlas.notification.embedded=true
atlas.notification.embedded=false
<#noparse>
#atlas.kafka.data=${sys:atlas.home}/data/kafka
</#noparse>
#atlas.kafka.zookeeper.connect=localhost:9026
#atlas.kafka.bootstrap.servers=localhost:9027
atlas.kafka.zookeeper.connect=${quorum}
atlas.kafka.bootstrap.servers=${kafka_hosts}
atlas.kafka.zookeeper.session.timeout.ms=30000
atlas.kafka.zookeeper.connection.timeout.ms=30000
atlas.kafka.zookeeper.sync.time.ms=2000
atlas.kafka.auto.commit.interval.ms=1000
atlas.kafka.hook.group.id=catalog_hook
atlas.kafka.entities.group.id=catalog_entities

atlas.kafka.enable.auto.commit=false
atlas.kafka.auto.offset.reset=earliest
atlas.kafka.session.timeout.ms=30000
atlas.kafka.offsets.topic.replication.factor=1
atlas.kafka.poll.timeout.ms=3000

atlas.notification.create.topics=true
<#if dependencies.KAFKA.roles.KAFKA_SERVER?size gte 2>
atlas.notification.replicas=2
<#else>
atlas.notification.replicas=1
</#if>
atlas.notification.topic.hook=${service['kafka.topic.catalog.hook']}
atlas.notification.topic.entities=${service['kafka.topic.catalog.entities']}
atlas.notification.log.failed.messages=true
atlas.notification.consumer.retry.interval=500
atlas.notification.hook.retry.interval=1000
# Enable for Kerberized Kafka clusters
atlas.notification.kafka.service.principal=kafka/${localhostname?lower_case}@${service.realm}
atlas.notification.kafka.keytab.location=/etc/keytabs/keytab
atlas.notification.hook.numthreads=1

## Server port configuration
#atlas.server.http.port=21000
atlas.server.http.port=${service['catalog.platform.http.port']}
#atlas.server.https.port=21443

#########  Security Properties  #########

# SSL config
atlas.enableTLS=false

#truststore.file=/path/to/truststore.jks
#cert.stores.credential.provider.path=jceks://file/path/to/credentialstore.jceks

#following only required for 2-way SSL
#keystore.file=/path/to/keystore.jks

# Authentication config

atlas.authentication.method.kerberos=<#if service.auth = "kerberos">true<#else>false</#if>
atlas.authentication.method.file=false
atlas.authentication.method.ldap=false

#### ldap.type= LDAP or AD
atlas.authentication.method.ldap.type=none

#### user credentials file
#atlas.authentication.method.file.filename=users-credentials.properties

### groups from UGI
#atlas.authentication.method.ldap.ugi-groups=true
<#noparse>
######## LDAP properties #########
#atlas.authentication.method.ldap.url=ldap://<ldap server url>:389
#atlas.authentication.method.ldap.userDNpattern=uid={0},ou=People,dc=example,dc=com
#atlas.authentication.method.ldap.groupSearchBase=dc=example,dc=com
#atlas.authentication.method.ldap.groupSearchFilter=(member=uid={0},ou=Users,dc=example,dc=com)
#atlas.authentication.method.ldap.groupRoleAttribute=cn
#atlas.authentication.method.ldap.base.dn=dc=example,dc=com
#atlas.authentication.method.ldap.bind.dn=cn=Manager,dc=example,dc=com
#atlas.authentication.method.ldap.bind.password=<password>
#atlas.authentication.method.ldap.referral=ignore
#atlas.authentication.method.ldap.user.searchfilter=(uid={0})
#atlas.authentication.method.ldap.default.role=<default role>


######### Active directory properties #######
#atlas.authentication.method.ldap.ad.domain=example.com
#atlas.authentication.method.ldap.ad.url=ldap://<AD server url>:389
#atlas.authentication.method.ldap.ad.base.dn=(sAMAccountName={0})
#atlas.authentication.method.ldap.ad.bind.dn=CN=team,CN=Users,DC=example,DC=com
#atlas.authentication.method.ldap.ad.bind.password=<password>
#atlas.authentication.method.ldap.ad.referral=ignore
#atlas.authentication.method.ldap.ad.user.searchfilter=(sAMAccountName={0})
#atlas.authentication.method.ldap.ad.default.role=<default role>

#########  JAAS Configuration ########

#atlas.jaas.KafkaClient.loginModuleName = com.sun.security.auth.module.Krb5LoginModule
#atlas.jaas.KafkaClient.loginModuleControlFlag = required
#atlas.jaas.KafkaClient.option.useKeyTab = true
#atlas.jaas.KafkaClient.option.storeKey = true
#atlas.jaas.KafkaClient.option.serviceName = kafka
#atlas.jaas.KafkaClient.option.keyTab = /etc/security/keytabs/atlas.service.keytab
#atlas.jaas.KafkaClient.option.principal = atlas/_HOST@EXAMPLE.COM
</#noparse>
#########  Server Properties  #########
#atlas.rest.address=http://localhost:21000
atlas.rest.address=http://localhost:${service['catalog.platform.http.port']}
# If enabled and set to true, this will run setup steps when the server starts
atlas.server.run.setup.on.start=false

#########  Entity Audit Configs  #########
#atlas.audit.hbase.tablename=apache_atlas_entity_audit
#atlas.audit.zookeeper.session.timeout.ms=1000
#atlas.audit.hbase.zookeeper.quorum=localhost:2181

#########  High Availability Configuration ########
atlas.server.ha.enabled=false
#### Enabled the configs below as per need if HA is enabled #####
#atlas.server.ids=id1
#atlas.server.address.id1=localhost:21000
#atlas.server.ha.zookeeper.connect=localhost:2181
#atlas.server.ha.zookeeper.retry.sleeptime.ms=1000
#atlas.server.ha.zookeeper.num.retries=3
#atlas.server.ha.zookeeper.session.timeout.ms=20000
## if ACLs need to be set on the created nodes, uncomment these lines and set the values ##
<#noparse>
#atlas.server.ha.zookeeper.acl=<scheme>:<id>
#atlas.server.ha.zookeeper.auth=<scheme>:<authinfo>
</#noparse>


######### Atlas Authorization #########
atlas.authorizer.impl=NONE
atlas.authorizer.simple.authz.policy.file=atlas-simple-authz-policy.json

#########  Type Cache Implementation ########
# A type cache class which implements
# org.apache.atlas.typesystem.types.cache.TypeCache.
# The default implementation is org.apache.atlas.typesystem.types.cache.DefaultTypeCache which is a local in-memory type cache.
#atlas.TypeCache.impl=

#########  Performance Configs  #########
#atlas.graph.storage.lock.retries=10
#atlas.graph.storage.cache.db-cache-time=120000

#########  CSRF Configs  #########
atlas.rest-csrf.enabled=false
atlas.rest-csrf.browser-useragents-regex=^Mozilla.*,^Opera.*,^Chrome.*
atlas.rest-csrf.methods-to-ignore=GET,OPTIONS,HEAD,TRACE
atlas.rest-csrf.custom-header=X-XSRF-HEADER
<#noparse>
############ KNOX Configs ################
#atlas.sso.knox.browser.useragent=Mozilla,Chrome,Opera
#atlas.sso.knox.enabled=true
#atlas.sso.knox.providerurl=https://<knox gateway ip>:8443/gateway/knoxsso/api/v1/websso
#atlas.sso.knox.publicKey=

############ Atlas Metric/Stats configs ################
# Format: atlas.metric.query.<key>.<name>
#atlas.metric.query.cache.ttlInSecs=900
#atlas.metric.query.general.typeCount=
#atlas.metric.query.general.typeUnusedCount=
#atlas.metric.query.general.entityCount=
#atlas.metric.query.general.tagCount=
#atlas.metric.query.general.entityDeleted=
#
#atlas.metric.query.entity.typeEntities=
#atlas.metric.query.entity.entityTagged=
#
#atlas.metric.query.tags.entityTags=
</#noparse>
#########  Compiled Query Cache Configuration  #########

# The size of the compiled query cache.  Older queries will be evicted from the cache
# when we reach the capacity.

#atlas.CompiledQueryCache.capacity=1000

# Allows notifications when items are evicted from the compiled query
# cache because it has become full.  A warning will be issued when
# the specified number of evictions have occurred.  If the eviction
# warning threshold <= 0, no eviction warnings will be issued.

#atlas.CompiledQueryCache.evictionWarningThrottle=0


#########  Full Text Search Configuration  #########

#Set to false to disable full text search.
#atlas.search.fulltext.enable=true

#########  Gremlin Search Configuration  #########

#Set to false to disable gremlin search.
atlas.search.gremlin.enable=false


########## Add http headers ###########
<#noparse>
#atlas.headers.Access-Control-Allow-Origin=*
#atlas.headers.Access-Control-Allow-Methods=GET,OPTIONS,HEAD,PUT,POST
#atlas.headers.<headerName>=<headerValue>
</#noparse>
#atlas.use.index.query.to.find.entity.by.unique.attributes=true

## Kafka Kerberos Config ###
<#if service.auth = "kerberos">
atlas.kafka.security.protocol=SASL_PLAINTEXT
atlas.kafka.sasl.mechanism=GSSAPI
atlas.kafka.sasl.kerberos.service.name=kafka
#atlas.kafka.sasl.kerberos.service.principal.instance=${localhostname?lower_case}
# kafka client jaas conf, modify principal/keytab as need, and make sure keytab file exist & readable
java.security.auth.login.config=/etc/${service.sid}/conf/kafka_client_jaas.conf
</#if>

### Hyperbase Kerberos Config ###
hyperbase.kerberos.principal=hbase/${localhostname?lower_case}@${service.realm}
hyperbase.kerberos.keytab=${service.keytab}