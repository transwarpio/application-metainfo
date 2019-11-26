<#if dependencies.ZOOKEEPER??>
  <#assign zookeeper=dependencies.ZOOKEEPER quorums=[]>
  <#list zookeeper.roles.ZOOKEEPER as role>
    <#assign quorums += [role.hostname]>
  </#list>
  <#assign quorum = quorums?join(",")>
</#if>
<#macro serviceLabel>
    serviceId: ${service.id }
    clusterId: ${service.clusterId}
</#macro>
<#macro roleLabel>
    roleId: ${.data_model['role.id']}
    roleType: ${.data_model['role.name']}
<#if .data_model['role.groupId'] ??>
    roleGroupId: ${.data_model['role.groupId']}
</#if>
    nodeId: ${.data_model['node.id']}
    rackId: ${.data_model['node.rackId']}
    hostname: ${.data_model['localhostname']}
</#macro>
sources:
- name: kafka_server_topics_in_rate_source
  className: io.transwarp.tdh.metrics.source.JMXSource
  props:
    url: "service:jmx:rmi:///jndi/rmi://${localhostname}:${service['kafka.jmx.remote.port']}/jmxrmi"
    bean: "kafka.server:type=BrokerTopicMetrics,name=BytesInPerSec"

- name: kafka_server_topics_out_rate_source
  className: io.transwarp.tdh.metrics.source.JMXSource
  props:
    url: "service:jmx:rmi:///jndi/rmi://${localhostname}:${service['kafka.jmx.remote.port']}/jmxrmi"
    bean: "kafka.server:type=BrokerTopicMetrics,name=BytesOutPerSec"

- name: kafka_server_topics_messages_in_source
  className: io.transwarp.tdh.metrics.source.JMXSource
  props:
    url: "service:jmx:rmi:///jndi/rmi://${localhostname}:${service['kafka.jmx.remote.port']}/jmxrmi"
    bean: "kafka.server:type=BrokerTopicMetrics,name=MessagesInPerSec"

- name: kafka_server_topics_failed_fetch_source
  className: io.transwarp.tdh.metrics.source.JMXSource
  props:
    url: "service:jmx:rmi:///jndi/rmi://${localhostname}:${service['kafka.jmx.remote.port']}/jmxrmi"
    bean: "kafka.server:type=BrokerTopicMetrics,name=FailedFetchRequestsPerSec"

- name: kafka_server_topics_failed_produce_source
  className: io.transwarp.tdh.metrics.source.JMXSource
  props:
    url: "service:jmx:rmi:///jndi/rmi://${localhostname}:${service['kafka.jmx.remote.port']}/jmxrmi"
    bean: "kafka.server:type=BrokerTopicMetrics,name=FailedProduceRequestsPerSec"

- name: kafka_server_replica_max_lag_source
  className: io.transwarp.tdh.metrics.source.JMXSource
  props:
    url: "service:jmx:rmi:///jndi/rmi://${localhostname}:${service['kafka.jmx.remote.port']}/jmxrmi"
    bean: "kafka.server:type=ReplicaFetcherManager,name=MaxLag,clientId=Replica"

- name: kafka_server_min_fetch_rate_source
  className: io.transwarp.tdh.metrics.source.JMXSource
  props:
    url: "service:jmx:rmi:///jndi/rmi://${localhostname}:${service['kafka.jmx.remote.port']}/jmxrmi"
    bean: "kafka.server:type=ReplicaFetcherManager,name=MinFetchRate,clientId=Replica"

- name: kafka_server_partition_count_source
  className: io.transwarp.tdh.metrics.source.JMXSource
  props:
    url: "service:jmx:rmi:///jndi/rmi://${localhostname}:${service['kafka.jmx.remote.port']}/jmxrmi"
    bean: "kafka.server:type=ReplicaManager,name=PartitionCount"

- name: kafka_server_under_replicated_partition_source
  className: io.transwarp.tdh.metrics.source.JMXSource
  props:
    url: "service:jmx:rmi:///jndi/rmi://${localhostname}:${service['kafka.jmx.remote.port']}/jmxrmi"
    bean: "kafka.server:type=ReplicaManager,name=UnderReplicatedPartitions"

- name: kafka_server_leader_election_rate_source
  className: io.transwarp.tdh.metrics.source.JMXSource
  props:
    url: "service:jmx:rmi:///jndi/rmi://${localhostname}:${service['kafka.jmx.remote.port']}/jmxrmi"
    bean: "kafka.controller:type=ControllerStats,name=LeaderElectionRateAndTimeMs"

- name: kafka_server_broker_status
  className: io.transwarp.tdh.metrics.source.JMXSource
  props:
    url: "service:jmx:rmi:///jndi/rmi://${localhostname}:${service['kafka.jmx.remote.port']}/jmxrmi"
    bean: "kafka.server:type=KafkaServer,name=BrokerState"

metrics:
- name: kafka_server_topics_bytes_in_per_sec
  fixedLabels:
    <@serviceLabel/>
    <@roleLabel/>
  type: GAUGE
  help: "Aggregate incoming byte rate. Unit: bytes/s"
  delaySec: 61
  source: kafka_server_topics_in_rate_source
  scrape:
    jsonPath: "$.beans[0].OneMinuteRate"

- name: kafka_server_topics_bytes_out_per_sec
  fixedLabels:
    <@serviceLabel/>
    <@roleLabel/>
  type: GAUGE
  help: "Aggregate outgoing byte rate. Unit: bytes/s"
  delaySec: 61
  source: kafka_server_topics_out_rate_source
  scrape:
    jsonPath: "$.beans[0].OneMinuteRate"

- name: kafka_server_topics_messages_in_per_sec
  fixedLabels:
    <@serviceLabel/>
    <@roleLabel/>
  type: GAUGE
  help: "All topics Messages in rate. Unit: count/s"
  delaySec: 61
  source: kafka_server_topics_messages_in_source
  scrape:
    jsonPath: "$.beans[0].OneMinuteRate"

- name: kafka_server_topics_failed_fetch_request_per_sec
  fixedLabels:
    <@serviceLabel/>
    <@roleLabel/>
  type: GAUGE
  help: "Failed fetch requests (per second) from consumers. Unit: count/s"
  delaySec: 61
  source: kafka_server_topics_failed_fetch_source
  scrape:
    jsonPath: "$.beans[0].OneMinuteRate"

- name: kafka_server_topics_failed_produce_request_per_sec
  fixedLabels:
    <@serviceLabel/>
    <@roleLabel/>
  type: GAUGE
  help: "Failed fetch requests (per second) from producer. Unit: count/s"
  delaySec: 61
  source: kafka_server_topics_failed_produce_source
  scrape:
    jsonPath: "$.beans[0].OneMinuteRate"

- name: kafka_server_replica_max_lag
  fixedLabels:
    <@serviceLabel/>
    <@roleLabel/>
  type: GAUGE
  help: "Maximum number of messages consumer is behind producer. Unit: count"
  delaySec: 61
  source: kafka_server_replica_max_lag_source
  scrape:
    jsonPath: "$.beans[0].Value"

- name: kafka_server_min_fetch_rate
  fixedLabels:
    <@serviceLabel/>
    <@roleLabel/>
  type: GAUGE
  help: "Minimum rate a consumer fetches requests to the broker. Unit: count"
  delaySec: 61
  source: kafka_server_min_fetch_rate_source
  scrape:
    jsonPath: "$.beans[0].Value"

- name: kafka_server_partition_count
  fixedLabels:
    <@serviceLabel/>
    <@roleLabel/>
  type: GAUGE
  help: "Total partition counts of a single broker. Unit: count"
  delaySec: 61
  source: kafka_server_partition_count_source
  scrape:
    jsonPath: "$.beans[0].Value"

- name: kafka_server_under_replicated_partition
  fixedLabels:
    <@serviceLabel/>
    <@roleLabel/>
  type: GAUGE
  help: "Number of unreplicated partitions. Unit: count"
  delaySec: 61
  source: kafka_server_under_replicated_partition_source
  scrape:
    jsonPath: "$.beans[0].Value"

- name: kafka_server_leader_election_rate
  fixedLabels:
    <@serviceLabel/>
    <@roleLabel/>
  type: GAUGE
  help: "leader election rate and latency, reports the rate of leader elections (per second) and the total time the cluster went without a leader (in milliseconds). Unit: count/s"
  delaySec: 61
  source: kafka_server_leader_election_rate_source
  scrape:
    jsonPath: "$.beans[0].OneMinuteRate"

- name: kafka_server_brokers_status
  fixedLabels:
    <@serviceLabel/>
    <@roleLabel/>
  type: GAUGE
  help: "Status of brokers."
  delaySec: 61
  source: kafka_server_broker_status
  scrape:
    jsonPath: "$.beans[0].Value"
