<#if service.roles.INCEPTOR_SLIPSTREAMSTUDIO??>
akka.remote.netty.tcp.hostname=${service.roles.INCEPTOR_SLIPSTREAMSTUDIO[0]['hostname']}
akka.remote.netty.tcp.port=${service['slipstream.studio.akkaserver.port']}
</#if>
#########################################
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
