# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# see kafka.server.KafkaConfig for additional details and defaults
<#--handle dependent.zookeeper-->
<#if dependencies.ZOOKEEPER??>
    <#assign zookeeper=dependencies.ZOOKEEPER quorums=[]>
    <#list zookeeper.roles.ZOOKEEPER as role>
        <#assign quorums += [role.hostname + ":" + zookeeper["zookeeper.client.port"]]>
    </#list>
    <#assign quorum = quorums?join(",")>
</#if>
############################# Server Basics #############################

# The id of the broker. This must be set to a unique integer for each broker.
<#assign nodeId=.data_model['node.id']>
broker.id=${nodeId}

############################# Socket Server Settings #############################

# The port the socket server listens on
port=${service['kmq.port']}

# Hostname the broker will bind to and advertise to producers and consumers.
# If not set, the server will bind to all interfaces and advertise the value returned from
# from java.net.InetAddress.getCanonicalHostName().
host.name=${localhostname}

# The number of threads handling network requests
num.network.threads=${service['kmq.num.network.threads']}

# The number of threads doing disk I/O
num.io.threads=${service['kmq.num.io.threads']}

# The send buffer (SO_SNDBUF) used by the socket server
socket.send.buffer.bytes=${service['kmq.socket.send.buffer.bytes']}

# The receive buffer (SO_RCVBUF) used by the socket server
socket.receive.buffer.bytes=${service['kmq.socket.receive.buffer.bytes']}

# The maximum size of a request that the socket server will accept (protection against OOM)
socket.request.max.bytes=${service['kmq.socket.request.max.bytes']}


############################# Log Basics #############################

# A comma seperated list of directories under which to store log files
log.dirs=${service['kmq.log.dirs']}

# The number of logical partitions per topic per server. More partitions allow greater parallelism
# for consumption, but also mean more files.
num.partitions=${service['kmq.num.partitions']}

############################# Log Flush Policy #############################

# The following configurations control the flush of data to disk. This is among the most
# important performance knob in kafka.
# There are a few important trade-offs here:
#    1. Durability: Unflushed data may be lost if you are not using replication.
#    2. Latency: Very large flush intervals may lead to latency spikes when the flush does occur as there will be a lot of data to flush.
#    3. Throughput: The flush is generally the most expensive operation, and a small flush interval may lead to exceessive seeks.
# The settings below allow one to configure the flush policy to flush data after a period of time or
# every N messages (or both). This can be done globally and overridden on a per-topic basis.

# The number of messages to accept before forcing a flush of data to disk
log.flush.interval.messages=${service['kmq.log.flush.interval.messages']}

# The maximum amount of time a message can sit in a log before we force a flush
log.flush.interval.ms=${service['kmq.log.flush.interval.ms']}

# Per-topic overrides for log.flush.interval.ms
log.flush.interval.ms.per.topic=

log.flush.scheduler.interval.ms=${service['kmq.log.flush.scheduler.interval.ms']}

############################# Log Retention Policy #############################

# The following configurations control the disposal of log segments. The policy can
# be set to delete segments after a period of time, or after a given size has accumulated.
# A segment will be deleted whenever *either* of these criteria are met. Deletion always happens
# from the end of the log.

# The minimum age of a log file to be eligible for deletion
log.retention.hours=${service['kmq.log.retention.hours']}

log.retention.hours.per.topic=

log.retention.bytes=${service['kmq.log.retention.bytes']}

log.retention.bytes.per.topic=

log.retention.check.interval.ms=${service['kmq.log.retention.check.interval.ms']}

log.roll.hours=${service['kmq.log.roll.hours']}

# A size-based retention policy for logs. Segments are pruned from the log as long as the remaining
# segments don't drop below log.retention.bytes.
#log.retention.bytes=1073741824

# The maximum size of a log segment file. When this size is reached a new log segment will be created.
log.segment.bytes=${service['kmq.log.segment.bytes']}

# The interval at which log segments are checked to see if they can be deleted according
# to the retention policies
log.cleanup.interval.mins=${service['kmq.log.cleanup.interval.mins']}

log.index.size.max.bytes=${service['kmq.log.index.size.max.bytes']}

log.index.interval.bytes=${service['kmq.log.index.interval.bytes']}

############################# Zookeeper #############################

# Zookeeper connection string (see zookeeper docs for details).
# This is a comma separated host:port pairs, each corresponding to a zk
# server. e.g. "127.0.0.1:3000,127.0.0.1:3001,127.0.0.1:3002".
# You can also append an optional chroot string to the urls to specify the
# root directory for all kafka znodes.
zookeeper.connect=${quorum}

# Timeout in ms for connecting to zookeeper
zookeeper.connection.timeout.ms=${service['kmq.zookeeper.connection.timeout.ms']}

zookeeper.session.timeout.ms=${service['kmq.zookeeper.session.timeout.ms']}

zookeeper.sync.time.ms=${service['kmq.zookeeper.sync.time.ms']}

############################# Other ################################
message.max.bytes=${service['kmq.message.max.bytes']}

replica.fetch.max.bytes=${service['kmq.replica.fetch.max.bytes']}

queued.max.requests=${service['kmq.queued.max.requests']}

auto.create.topics.enable=${service['kmq.auto.create.topics.enable']}

controller.socket.timeout.ms=${service['kmq.controller.socket.timeout.ms']}

controller.message.queue.size=${service['kmq.controller.message.queue.size']}

default.replication.factor=${service['kmq.default.replication.factor']}

replica.lag.time.max.ms=${service['kmq.replica.lag.time.max.ms']}

replica.socket.timeout.ms=${service['kmq.replica.socket.timeout.ms']}

replica.socket.receive.buffer.bytes=${service['kmq.replica.socket.receive.buffer.bytes']}

replica.fetch.wait.max.ms=${service['kmq.replica.fetch.wait.max.ms']}

replica.fetch.min.bytes=${service['kmq.replica.fetch.min.bytes']}

num.replica.fetchers=${service['kmq.num.replica.fetchers']}

replica.high.watermark.checkpoint.interval.ms=${service['kmq.replica.high.watermark.checkpoint.interval.ms']}

fetch.purgatory.purge.interval.requests=${service['kmq.fetch.purgatory.purge.interval.requests']}

producer.purgatory.purge.interval.requests=${service['kmq.producer.purgatory.purge.interval.requests']}

controlled.shutdown.enable=${service['kmq.controlled.shutdown.enable']}

controlled.shutdown.max.retries=${service['kmq.controlled.shutdown.max.retries']}

controlled.shutdown.retry.backoff.ms=${service['kmq.controlled.shutdown.retry.backoff.ms']}

############################# security #############################
# Authentication method: simple, kerberos or ipaddress
# Property principal and keytab should also be configured when authentication set to kerberos.
authentication=${service['auth']}

# whether cache acl in memory or not
#acl.cache=true
<#if service.auth = "kerberos">
# principal for kerberos authentication
principal=kafka/${localhostname}

# keytab for kerberos authentication
keytab=/etc/${service.sid}/conf/kafka.keytab
</#if>
