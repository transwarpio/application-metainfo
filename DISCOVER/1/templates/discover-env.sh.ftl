export DISCOVER_LOG_DIR=/var/log/${service.sid}
export LOCAL_CRAN=${service.roles['DISCOVER_LOCAL-CRAN'][0].hostname}
export HADOOP_CONF_DIR＝/etc/${dependencies.HDFS.sid}/conf:/etc/${dependencies.YARN.sid}/conf
cp /etc/${service.sid}/conf/rstudio /etc/pam.d/
cp /etc/${service.sid}/conf/sssd.conf /etc/sssd/
cp /etc/${service.sid}/conf/krb5.conf /etc/
