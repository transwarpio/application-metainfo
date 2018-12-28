export DISCOVER_LOG_DIR=/var/log/${service.sid}
<#if service.roles['DISCOVER_LOCAL-CRAN']??>
export LOCAL_CRAN=${service.roles['DISCOVER_LOCAL-CRAN'][0].hostname + ":" + service['discover.local-cran.port']}
</#if>
export HADOOP_CONF_DIR=/etc/${dependencies.YARN.sid}/conf
cp /etc/${service.sid}/conf/rstudio /etc/pam.d/
[ -f /etc/${service.sid}/conf/sssd.conf ] && cp /etc/${service.sid}/conf/sssd.conf /etc/sssd/
[ -f /etc/${service.sid}/conf/krb5.conf ] && cp /etc/${service.sid}/conf/krb5.conf /etc/
<#if service.auth = "kerberos">
cp /etc/${service.sid}/conf/krb5.conf /etc/
</#if>
