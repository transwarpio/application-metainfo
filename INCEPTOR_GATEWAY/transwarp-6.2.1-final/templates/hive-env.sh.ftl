# security environment
<#if service.auth = "kerberos">
export KRB_ENABLE=true
export INCEPTOR_GATEWAY_PRINCIPAL=hive/_HOST@${service.realm}
export INCEPTOR_GATEWAY_KEYTAB=/etc/${service.sid}/conf/inceptor_gateway.keytab
export MASTERPRINCIPAL=hive/${localhostname}
export KEYTAB=/etc/${service.sid}/conf/inceptor_gateway.keytab
export KRB_PLUGIN_ENABLE=true
<#else>
export KRB_ENABLE=false
</#if>
export KRB_MOUNTED_CONF_PATH=/etc/${service.sid}/conf/krb5.conf
