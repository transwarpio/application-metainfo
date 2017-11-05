<#assign license_servers=[]>
<#list dependencies.LICENSE_SERVICE.roles.LICENSE_NODE as server>
    <#assign license_servers += [(server.hostname + ":" + dependencies.LICENSE_SERVICE[server.hostname]["zookeeper.client.port"])]>
</#list>

<#assign server_count=service.roles.SEARCH_SERVER?size>
<#assign es_nodes=[] master_nodes=[] master_node_count=0>
<#list service.roles.SEARCH_SERVER as server>
    <#if service[server.hostname]['node.master']="true">
        <#assign master_nodes+=[server.hostname] master_node_count+=1>
    </#if>
    <#assign es_nodes+=[server.hostname]>
</#list>
# ======================== Elasticsearch Configuration =========================
#
# NOTE: Elasticsearch comes with reasonable defaults for most settings.
#       Before you set out to tweak and tune the configuration, make sure you
#       understand what are you trying to accomplish and the consequences.
#
# The primary way of configuring a node is via this file. This template lists
# the most important settings you may want to configure for a production cluster.
#
# Please see the documentation for further information on configuration options:
# <http://www.elastic.co/guide/en/elasticsearch/reference/current/setup-configuration.html>
#
# ---------------------------------- Cluster -----------------------------------
#
# Use a descriptive name for your cluster:
#
cluster.name: ${service['cluster.name']}
#
# ------------------------------------ Node ------------------------------------
#
# Use a descriptive name for the node:
#
node.name: ${localhostname}
#
# Add custom attributes to the node:
#
# node.attr.rack: r1
#
# Every node can be configured to allow or deny being eligible as the master,
# and to allow or deny to store the data.
#
# Allow this node to be eligible as a master node (enabled by default):
#
node.master: ${service['node.master']}
#
# Allow this node to store data (enabled by default):
#
node.data: ${service['node.data']}
#
# ----------------------------------- Paths ------------------------------------
#
# Path to directory where to store the data (separate multiple locations by comma):
#
path.data: ${service['path.data']}
#
# Path to log files:
#
path.logs: ${service['path.logs']}
#
# ----------------------------------- Memory -----------------------------------
#
# Lock the memory on startup:
#
# bootstrap.mlockall: true
#
# Make sure that the `ES_HEAP_SIZE` environment variable is set to about half the memory
# available on the system and that the owner of the process is allowed to use this limit.
#
# Elasticsearch performs poorly when the system is swapping the memory.
#
# ---------------------------------- Network -----------------------------------
#
# Set the bind adress to a specific IP (IPv4 or IPv6):
#
network.bind_host: ${service['network.bind_host']}
network.publish_host: ${service['network.publish_host']}
#
# Set a custom port for HTTP:
#
http.port: ${service['http.port']}
transport.tcp.port: ${service['transport.tcp.port']}
#
# For more information, see the documentation at:
# <http://www.elastic.co/guide/en/elasticsearch/reference/current/modules-network.html>
#
# ---------------------------------- Gateway -----------------------------------
#
# Block initial recovery after a full cluster restart until N nodes are started:
#
gateway.recover_after_time: ${service['gateway.recover_after_time']}
gateway.recover_after_nodes: ${(server_count/2 +1)?int}
gateway.recover_after_data_nodes: ${(server_count/2 +1)?int}
gateway.recover_after_master_nodes: ${(master_node_count/2 +1)?int}
gateway.expected_nodes: ${server_count}
gateway.expected_data_nodes: ${server_count}
gateway.expected_master_nodes: ${master_node_count}
#
# For more information, see the documentation at:
# <http://www.elastic.co/guide/en/elasticsearch/reference/current/modules-gateway.html>
#
# --------------------------------- Discovery ----------------------------------
#
# Elasticsearch nodes will find each other via unicast, by default.
#
# Pass an initial list of hosts to perform discovery when new node is started:
# The default list of hosts is ["127.0.0.1", "[::1]"]
#
discovery.zen.ping.unicast.hosts: ${es_nodes?join(",")}
#
# Prevent the "split brain" by configuring the majority of nodes (total number of nodes / 2 + 1):
#
discovery.zen.minimum_master_nodes: ${service['discovery.zen.minimum_master_nodes']}
#
# For more information, see the documentation at:
# <http://www.elastic.co/guide/en/elasticsearch/reference/current/modules-discovery.html>
#
# ---------------------------------- Various -----------------------------------
#
# Disable starting multiple nodes on a single system:
#
# node.max_local_storage_nodes: 1
#
# Require explicit names when deleting indices:
#
# action.destructive_requires_name: true
#
# ---------------------------------- Thread Pool -------------------------------
#
# For more information, see the documentation at:
# <https://www.elastic.co/guide/en/elasticsearch/reference/current/modules-threadpool.html>
#
thread_pool:
  bulk:
    queue_size: ${service['thread_pool.bulk.queue_size']}

license.zookeeper.quorum: ${license_servers?join(",")}
index.shard.path.selector: ${service['index.shard.path.selector']}
bootstrap.system_call_filter: false
http.cors.enabled: true
http.cors.allow-origin: "*"
indices.fielddata.cache.size: ${service['indices.fielddata.cache.size']}
index.store.type: ${service['index.store.type']}
index.translog.durability: ${service['index.translog.durability']}

transport.type: netty3
http.type: netty3
