<#if service['prometheus.web.enable-admin-api'] == "true">
    <#assign PROMETHEUS_ENABLE_ADMIN="--web.enable-admin-api">
<#else>
    <#assign PROMETHEUS_ENABLE_ADMIN="">
</#if>

<#if service['prometheus.web.enable-lifecycle'] == "true">
    <#assign PROMETHEUS_ENABLE_LIFECYCLE="--web.enable-lifecycle">
<#else>
    <#assign PROMETHEUS_ENABLE_LIFECYCLE="">
</#if>
#!/usr/bin/env bash
export PROMETHEUS_DATA_DIR=${service['prometheus.data.dir']}

export PROMETHEUS_OPTS="--config.file=/etc/${service.sid}/conf/prometheus/prometheus.yml \
                        --storage.tsdb.path=${service['prometheus.data.dir']} \
                        --storage.tsdb.retention.time=${service['prometheus.storage.retention.time.days']}d \
                        --storage.tsdb.min-block-duration=${service['prometheus.min-block-duration.hours']}h \
                        --storage.tsdb.max-block-duration=${service['prometheus.max-block-duration.hours']}h \
                        --web.console.libraries=/usr/share/prometheus/console_libraries \
                        --web.console.templates=/usr/share/prometheus/consoles \
                        --web.listen-address=:${service['prometheus.web.port']} \
                        ${PROMETHEUS_ENABLE_ADMIN} \
                        ${PROMETHEUS_ENABLE_LIFECYCLE}"
