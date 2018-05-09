slipstream.restclient.server.address=${service.roles.INCEPTOR_SERVER[0]['hostname']}:${service['inceptor.ui.port']}
slipstream.restclient.history.address=${service.roles.INCEPTOR_HISTORYSERVER[0]['hostname']}:${service['slipstream.historyserver.akka.listen.port']}
slipstream.eventstore.basedir=${service['slipstream.studio.eventstore.basedir']}
slipstream.eventstore.logrotation.hours=${service['slipstream.studio.eventstore.rotation.hours']}
###################################################
slipstream.restclient.connect.timeout=10000
slipstream.restclient.socket.timeout=10000
slipstream.restclient.stale.check=true
slipstream.restclient.conn-manager.timeout=5000
slipstream.restclient.max.perroute=100
slipstream.restclient.max.total=500
slipstream.eventstore.partialfile.mb=5
slipstream.eventstore.partialfile.minutes=60

########## Gateway akka config #######
slipstream.gateway.akka.host=${service.roles.INCEPTOR_SERVER[0]['hostname']}
slipstream.gateway.akka.port=${service['slipstream.gateway.akka.port']}
slipstream.gateway.akka.heartbeat.asktimeout=30
slipstream.gateway.akka.heartbeat.interval=30000
slipstream.gateway.akka.heartbeat.retry=5
slipstream.gateway.akka.heartbeat.retryinterval=5000

