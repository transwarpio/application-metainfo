<#if service.roles.INCEPTOR_SLIPSTREAMSTUDIO??>
alert4j.service=slipstreamstudio
<#else>
alert4j.service=
</#if>
#-- Email --
email.server.host=smtp.exmail.qq.com
email.server.port=465
email.server.ssl=true
email.validate=true
email.sender.username=streaming@transwarp.io
email.sender.password=
email.from.address=streaming@transwarp.io
email.to.addresses=streaming@transwarp.io

# -- akka--
<#if service.roles.INCEPTOR_SLIPSTREAMSTUDIO??>
alert.service.studio.akka.host=${service.roles.INCEPTOR_SLIPSTREAMSTUDIO[0]['hostname']}
alert.service.studio.akka.port=${service['slipstream.studio.akkaserver.port']}
alert.service.studio.akka.actorsystemname=SlipstreamStudio
alert.service.studio.akka.actorTimeout=120

# -- 绑定的本地alert4j akka client的地址与端口. 如果别人要连过来得通过30090连.
# -- slipstream绑定30090, monitor绑定30030., slipstream作为client连接monitor.
alert.service.client.akka.host=${localhostname}
alert.service.client.akka.port=${service['alert.service.client.akka.port']}
alert.service.client.akka.asktimeout=10
alert.service.client.akka.retrynums=5
alert.service.client.akka.retryinterval=10000
</#if>