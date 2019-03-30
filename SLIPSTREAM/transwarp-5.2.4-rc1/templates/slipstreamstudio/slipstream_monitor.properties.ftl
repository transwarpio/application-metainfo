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

