export SLIPSTREAM_STUDIO_LOG_DIR=/var/log/${service.sid}
export SLIPSTREAM_STUDIO_CONF_DIR=/etc/${service.sid}/conf
export SLIPSTREAM_STUDIO_HTTP_PORT=${service['slipstream.studio.http.port']}

<#if service[.data_model["localhostname"]]['slipstream.studio.projects.output.dir']??>
export SLIPSTREAM_STUDIO_PROJOUTPUT_DIR=${service[.data_model["localhostname"]]['slipstream.studio.projects.output.dir']}
</#if>

<#if service[.data_model["localhostname"]]['slipstream.studio.project.repo.dir']??>
export SLIPSTREAM_STUDIO_PROJREPO_DIR=${service[.data_model["localhostname"]]['slipstream.studio.project.repo.dir']}
</#if>

<#if service[.data_model["localhostname"]]['slipstream.studio.eventstore.basedir']??>
export SLIPSTREAM_STUDIO_EVENTSTORE_BASEDIR=${service[.data_model["localhostname"]]['slipstream.studio.eventstore.basedir']}
</#if>

<#if service.auth = "kerberos">
export SLIPSTREAM_STUDIO_OPT="-Djava.security.krb5.conf=/etc/${service.sid}/conf/krb5.conf"
cp /etc/${service.sid}/conf/krb5.conf /etc/
</#if>