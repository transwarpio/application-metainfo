########################################
# Akka relate configuration.
########################################
akka.daemonic=on
akka.jvm-exit-on-fatal-error=off
akka.actor.provider=akka.remote.RemoteActorRefProvider
akka.actor.default-dispatcher.throughput=15
akka.remote.transport-failure-detector.heartbeat-interval=1000 s
akka.remote.transport-failure-detector.acceptable-heartbeat-pause=600 s
akka.remote.netty.tcp.transport-class=akka.remote.transport.netty.NettyTransport
akka.remote.netty.tcp.execution-pool-size=4
akka.remote.netty.tcp.maximum-frame-size=10485760B
akka.remote.netty.tcp.tcp-nodelay=on
akka.remote.netty.tcp.connection-timeout=100 s

# generate by manager
<#if service.roles.INCEPTOR_SLIPSTREAMSTUDIO??>
akka.remote.netty.tcp.hostname=${service.roles.INCEPTOR_SLIPSTREAMSTUDIO[0]['hostname']}
akka.remote.netty.tcp.port=${service['slipstream.studio.akkaserver.port']}
</#if>

########################################
# Slipstream Gateway rest client config
########################################
slipstream.restclient.connect.timeout=10000
slipstream.restclient.socket.timeout=10000
slipstream.restclient.stale.check=true
slipstream.restclient.conn-manager.timeout=5000
slipstream.restclient.max.perroute=100
slipstream.restclient.max.total=500

# generate by manager.
<#if dependencies.SLIPSTREAM??>
<#assign slipstream_server=dependencies.SLIPSTREAM.roles.INCEPTOR_SERVER[0]['hostname']>
slipstream.restclient.server.address=${slipstream_server}:${dependencies.SLIPSTREAM['inceptor.ui.port']}
slipstream.service.id=${dependencies.SLIPSTREAM.sid}
<#if dependencies.SLIPSTREAM.roles.INCEPTOR_HISTORYSERVER??>
<#assign historyserver=dependencies.SLIPSTREAM.roles.INCEPTOR_HISTORYSERVER[0]['hostname']>
slipstream.restclient.history.address=${historyserver}:${dependencies.SLIPSTREAM['slipstream.historyserver.akka.listen.port']}
</#if>
</#if>
slipstream.gateway.akka.host=${slipstream_server}
slipstream.gateway.akka.port=${dependencies.SLIPSTREAM['slipstream.gateway.akka.port']}
slipstream.server.ui.port=${dependencies.SLIPSTREAM['inceptor.ui.port']}
<#if dependencies.INCEPTOR_GATEWAY??>
slipstream.server.ha.enable=true
slipstream.guardian.token=
<#assign gateway_host=dependencies.INCEPTOR_GATEWAY.roles.INCEPTOR_GATEWAY[0]['hostname']>
<#assign gateway_port=dependencies.INCEPTOR_GATEWAY['inceptor.gateway.ui.port']>
slipstream.service.gateway.address=${gateway_host}:${gateway_port}
</#if>

########################################
# Event store config.
########################################
<#if service[.data_model["localhostname"]]['slipstream.studio.eventstore.basedir']??>
slipstream.eventstore.basedir=${service[.data_model["localhostname"]]['slipstream.studio.eventstore.basedir']}
</#if>
slipstream.eventstore.logrotation.hours=${service['slipstream.studio.eventstore.rotation.hours']}
slipstream.eventstore.partialfile.minutes=5
slipstream.eventstore.logrotation.hours=336

########################################
# Slipstream Gateway akka config
########################################
slipstream.gateway.akka.heartbeat.asktimeout=30
slipstream.gateway.akka.heartbeat.interval=60000
slipstream.gateway.akka.heartbeat.retry=5
slipstream.gateway.akka.heartbeat.retryinterval=5000


########################################
# Slipstream Gateway akka config
########################################
# Local maven location.
slipstream.studio.maven.home=/usr/lib/slipstream-studio/sdks/maven
slipstream.studio.maven.repo.dir=/usr/lib/slipstream-studio/.m2
slipstream.studio.dependent.transwarp.version=transwarp-6.0.1-rc3.0-rc0

# generate by manager.
slipstream.studio.projects.output.dir=${service['slipstream.studio.projects.output.dir']}
slipstream.studio.project.repo.dir=${service['slipstream.studio.project.repo.dir']}
slipstream.studio.rules.resource.dir=hdfs://${dependencies.HDFS.nameservices[0]}${service['slipstream.studio.rules.resource.dir']}


################################
# algorithm jar files in HDFS
################################
slipstream.studio.algorithm.hdfs.jar.dir=hdfs://${dependencies.HDFS.nameservices[0]}${service['slipstream.studio.algorithm.hdfs.jar.dir']}
slipstream.studio.algorithm.hdfs.tmp.jar.dir=hdfs://${dependencies.HDFS.nameservices[0]}${service['slipstream.studio.algorithm.hdfs.tmp.jar.dir']}

slipstream.studio.external.address=http://${service.roles.INCEPTOR_SLIPSTREAMSTUDIO[0]['ip']}:${service['slipstream.studio.http.port']}
############################# Custom and Other ###############################
<#list service['studio.properties'] as key, value>
${key}=${value}
</#list>