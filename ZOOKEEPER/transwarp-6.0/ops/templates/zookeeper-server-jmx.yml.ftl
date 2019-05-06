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
    nodeId: ${.data_model['role.nodeId']}
    rackId: ${.data_model['role.rackId']}
</#macro>
sources:
- name: zookeeper_server_source
  className: io.transwarp.tdh.metrics.source.JMXSource
  props:
    url: "service:jmx:rmi:///jndi/rmi://${localhostname}:${service['zookeeper.jmxremote.port']}/jmxrmi"
    bean: "org.apache.ZooKeeperService:name0=ReplicatedServer_id*,name1=replica.*,name2=*"

- name: zookeeper_operating_system_source
  className: io.transwarp.tdh.metrics.source.JMXSource
  props:
    url: "service:jmx:rmi:///jndi/rmi://${localhostname}:${service['zookeeper.jmxremote.port']}/jmxrmi"
    bean: "java.lang:type=OperatingSystem"

metrics:
- name: zookeeper_server_max_request_latency
  fixedLabels:
    <@serviceLabel/>
    <@roleLabel/>
  type: GAUGE
  help: "Maximal amount of time it takes for the server to respond to a client request(since the server was started). Unit: ms"
  delaySec: 61
  source: zookeeper_server_source
  scrape:
    jsonPath: "$.beans[0].MaxRequestLatency"

- name: zookeeper_server_min_request_latency
  fixedLabels:
    <@serviceLabel/>
    <@roleLabel/>
  type: GAUGE
  help: "Minimal amount of time it takes for the server to respond to a client request(since the server was started). Unit: ms"
  delaySec: 61
  source: zookeeper_server_source
  scrape:
    jsonPath: "$.beans[0].MinRequestLatency"

- name: zookeeper_server_avg_request_latency
  fixedLabels:
    <@serviceLabel/>
    <@roleLabel/>
  type: GAUGE
  help: "Average amount of time it takes for the server to respond to a client request(since the server was started). Unit: ms"
  delaySec: 61
  source: zookeeper_server_source
  scrape:
    jsonPath: "$.beans[0].AvgRequestLatency"

- name: zookeeper_server_packets_sent
  fixedLabels:
    <@serviceLabel/>
    <@roleLabel/>
  type: GAUGE
  help: "Number of client packets sent (responses and notifications) per second. Unit: count/s"
  delaySec: 61
  source: zookeeper_server_source
  scrape:
    jsonPath: "$.beans[0].PacketsSent"

- name: zookeeper_server_packets_received
  fixedLabels:
    <@serviceLabel/>
    <@roleLabel/>
  type: GAUGE
  help: "Number of client packets received (responses and notifications) per second. Unit: count/s"
  delaySec: 61
  source: zookeeper_server_source
  scrape:
    jsonPath: "$.beans[0].PacketsReceived"

- name: zookeeper_server_alive_connections
  fixedLabels:
    <@serviceLabel/>
    <@roleLabel/>
  type: GAUGE
  help: "Number of alive connections. Unit: count"
  delaySec: 61
  source: zookeeper_server_source
  scrape:
    jsonPath: "$.beans[0].NumAliveConnections"

- name: zookeeper_server_outstanding_requests
  fixedLabels:
    <@serviceLabel/>
    <@roleLabel/>
  type: GAUGE
  help: "Number of queued requests in the ZK server. Unit: count"
  delaySec: 61
  source: zookeeper_server_source
  scrape:
    jsonPath: "$.beans[0].OutstandingRequests"

- name: zookeeper_server_process_cpu_load
  fixedLabels:
    <@serviceLabel/>
    <@roleLabel/>
  type: GAUGE
  help: "'Recent cpu usage' for the Java Virtual Machine process. Unit: %"
  delaySec: 61
  source: zookeeper_operating_system_source
  scrape:
    jsonPath: "$.beans[0].ProcessCpuLoad"