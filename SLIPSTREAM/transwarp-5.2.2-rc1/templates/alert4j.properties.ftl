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
slipstreamstudio.server.host=${service.roles.INCEPTOR_SLIPSTREAMSTUDIO[0]['hostname']}
slipstreamstudio.server.port=${service['slipstream.studio.akkaserver.port']}
</#if>
slipstreamstudio.server.actor.timeout=120

# -- 绑定的本地alert4j akka client的地址与端口. 如果别人要连过来得通过30090连.
# -- slipstream绑定30090, monitor绑定30030., slipstream作为client连接monitor.
alert4j.host=${localhostname}
alert4j.port=${service['slipstream.studio.akkaserver.local.port']}