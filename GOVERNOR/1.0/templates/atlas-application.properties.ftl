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
# Graph Storage
#atlas.graph.storage.backend=berkeleyje
<#noparse>
#atlas.graph.storage.directory=${sys:atlas.home}/data/berkley
</#noparse>
#Hbase as stoarge backend
atlas.graph.storage.backend=hbase
#For standalone mode , specify localhost
#for distributed mode, specify zookeeper quorum here - For more information refer http://s3.thinkaurelius.com/docs/titan/current/hbase.html#_remote_server_mode_2
#atlas.graph.storage.hostname=localhost
atlas.graph.storage.hbase.regions-per-server=1
atlas.graph.storage.lock.wait-time=10000
# set the hbase table name
atlas.graph.storage.hbase.table=${service['atlas.graph.storage.hbase.table']}

#Solr
#atlas.graph.index.search.backend=solr5

# Solr cloud mode properties
#atlas.graph.index.search.solr.mode=cloud
#atlas.graph.index.search.solr.zookeeper-url=localhost:2181

#Solr http mode properties
#atlas.graph.index.search.solr.mode=http
#atlas.graph.index.search.solr.http-urls=http://localhost:8983/solr

# Graph Search Index
#ElasticSearch
atlas.graph.index.search.backend=elasticsearch
<#noparse>
atlas.graph.index.search.directory=${sys:atlas.home}/data/es
</#noparse>
#atlas.graph.index.search.elasticsearch.client-only=false
#cluster mode configure
<#--handle dependent.search-->
<#-- TODO modify es port-->
<#if dependencies.SEARCH??>
    <#assign search=dependencies.SEARCH searches=[]>
    <#list search.roles.SEARCH_SERVER as role>
        <#assign searches += [role.hostname]>
    </#list>
    <#assign search_hosts = searches?join(",")>
</#if>
atlas.graph.index.search.hostname=${search_hosts}
atlas.graph.index.search.http.port=9200
atlas.graph.index.search.index-name=${service['atlas.graph.index.search.index-name']}
atlas.graph.index.search.elasticsearch.client-only=true
atlas.graph.index.search.elasticsearch.cluster-name=${dependencies.SEARCH['cluster.name']}
atlas.graph.index.search.elasticsearch.local-mode=true
atlas.graph.index.search.elasticsearch.create.sleep=2000


#########  Notification Configs  #########
atlas.notification.embedded=false
<#noparse>
#atlas.kafka.data=${sys:atlas.home}/data/kafka
</#noparse>
<#--handle dependent.zookeeper-->
<#if dependencies.ZOOKEEPER??>
    <#assign zookeeper=dependencies.ZOOKEEPER quorums=[]>
    <#list zookeeper.roles.ZOOKEEPER as role>
        <#assign quorums += [role.hostname + ":" + zookeeper[role.hostname]["zookeeper.client.port"]]>
    </#list>
    <#assign quorum = quorums?join(",")>
</#if>
atlas.kafka.zookeeper.connect=${quorum}
<#if dependencies.ZOOKEEPER??>
    <#assign kafka=dependencies.KAFKA kafkas=[]>
    <#list kafka.roles.KAFKA_SERVER as role>
        <#assign kafkas += [role.hostname + ":" + kafka["kmq.port"]]>
    </#list>
    <#assign kafka_hosts = kafkas?join(",")>
</#if>
atlas.kafka.bootstrap.servers=${kafka_hosts}
atlas.kafka.zookeeper.session.timeout.ms=4000
atlas.kafka.zookeeper.connection.timeout.ms=2000
atlas.kafka.zookeeper.sync.time.ms=200
atlas.kafka.auto.commit.interval.ms=1000
atlas.kafka.auto.offset.reset=earliest
atlas.kafka.hook.group.id=${service['atlas.kafka.hook.group.id']}
atlas.kafka.auto.commit.enable=false
atlas.kafka.max.poll.records=10
atlas.kafka.max.poll.interval.ms=300000

### Create Kafka Topic Configs, Required in HA mode ###
atlas.notification.create.topics=true
# kafka topic partition number
atlas.notification.hook.numthreads=1
# kafka topic replica number, Its value should be set to more than 1 in HA mode
atlas.notification.replicas=2
atlas.notification.topics=ATLAS_HOOK

### Kafka Kerberos Config ###
<#if service.auth = "kerberos">
atlas.kafka.security.protocol=SASL_PLAINTEXT
atlas.kafka.sasl.mechanism=GSSAPI
atlas.kafka.sasl.kerberos.service.name=kafka
# kafka client jaas conf, modify principal/keytab as need, and make sure keytab file exist & readable
java.security.auth.login.config=/etc/${service.sid}/conf/kafka_client_jaas.conf
</#if>

#########  Hive Lineage Configs  #########
# This models reflects the base super types for Data and Process
#atlas.lineage.hive.table.type.name=DataSet
#atlas.lineage.hive.process.type.name=Process
#atlas.lineage.hive.process.inputs.name=inputs
#atlas.lineage.hive.process.outputs.name=outputs

## Schema
atlas.lineage.hive.table.schema.query.hive_table=hive_table where name='%s'\, columns
atlas.lineage.hive.table.schema.query.Table=Table where name='%s'\, columns

## Server port configuration
atlas.server.http.port=${service['governor.http.port']}
#atlas.server.https.port=21443

#########  Security Properties  #########

# SSL config
atlas.enableTLS=false

#truststore.file=/path/to/truststore.jks
#cert.stores.credential.provider.path=jceks://file/path/to/credentialstore.jceks

#following only required for 2-way SSL
#keystore.file=/path/to/keystore.jks

# Authentication config

# enabled:  true or false
atlas.http.authentication.enabled=false
# type:  simple or kerberos
atlas.http.authentication.type=simple

#########  Server Properties  #########
atlas.rest.address=http://localhost:21000
# If enabled and set to true, this will run setup steps when the server starts
#atlas.server.run.setup.on.start=false

#########  Entity Audit Configs  #########
atlas.audit.hbase.tablename=ATLAS_ENTITY_AUDIT_EVENTS
atlas.audit.zookeeper.session.timeout.ms=1000
atlas.audit.hbase.zookeeper.quorum=${quorum}

<#if service.roles.GOVERNOR_SERVER?size gt 1>
#########  High Availability Configuration ########
atlas.server.ha.enabled=true
#### Enabled the configs below as per need if HA is enabled #####
<#assign size=service.roles.GOVERNOR_SERVER?size ids=[]>
<#list 0..size-1 as i >
<#assign ids += ["id" + (i+1)]>
atlas.server.address.id${i + 1}=${service.roles.GOVERNOR_SERVER[i]['hostname']}:${service['governor.http.port']}
</#list>
<#assign id = ids?join(",")>

atlas.server.ids=${id}
atlas.server.ha.zookeeper.connect=${quorum}
atlas.server.ha.zookeeper.retry.sleeptime.ms=1000
atlas.server.ha.zookeeper.num.retries=3
atlas.server.ha.zookeeper.session.timeout.ms=20000

## if ACLs need to be set on the created nodes, uncomment these lines and set the values ##
#atlas.server.ha.zookeeper.acl=<scheme>:<id>
#atlas.server.ha.zookeeper.auth=<scheme>:<authinfo>
<#else>
atlas.server.ha.enabled=false
</#if>

#### atlas.login.method {FILE,LDAP,AD,GUARDIAN} ####
atlas.login.method=GUARDIAN
<#noparse>
### File path of users-credentials
atlas.login.credentials.file=${sys:atlas.home}/conf/users-credentials.properties

#########POLICY FILE PATH #########
atlas.auth.policy.file=${sys:atlas.home}/conf/policy-store.txt
</#noparse>
# Lineage / Effect Analysis, levels Configs
atlas.lineage.level.max=5
atlas.lineage.level.default=3

# repository initialize
#atlas.repository.initialize.import.threads=5
#atlas.repository.initialize.kafka.threads=3

# notify service address
<#if dependencies.NOTIFICATION??>
notify.rest.service.address=http://${dependencies.NOTIFICATION.roles.NOTIFICATION_SERVER[0]['hostname']}:${dependencies.NOTIFICATION['notification.http.port']}/
</#if>

# check service state period
atlas.dependency.services.state.check.period.ms=900000

# atlas authentication
#### authentication method {simple, kerberos}
atlas.authentication.method=${service.auth}
atlas.authentication.principal=hbase/${localhostname}@${service.realm}
atlas.authentication.keytab=${service.keytab}

<#assign license_servers=[]>
<#list dependencies.LICENSE_SERVICE.roles.LICENSE_NODE as server>
    <#assign license_servers += [(server.hostname + ":" + dependencies.LICENSE_SERVICE[server.hostname]["zookeeper.client.port"])]>
</#list>
atlas.license.servers=${license_servers?join(",")}
