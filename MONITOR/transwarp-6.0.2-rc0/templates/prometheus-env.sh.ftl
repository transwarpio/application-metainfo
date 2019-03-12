<#if service[.data_model["localhostname"]]?? && service[.data_model["localhostname"]]['prometheus.data.dir']??>
# Export prometheus data dir
export PROMETHEUS_DATA_DIR=${service[.data_model["localhostname"]]['prometheus.data.dir']}
</#if>