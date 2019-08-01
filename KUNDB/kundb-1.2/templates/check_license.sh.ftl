#!/bin/bash
<#if service.roles.LICENSE_PROXY??>
  <#list service.roles.LICENSE_PROXY as olicense>
    <#assign licenseHost= olicense.hostname>
    <#break>
  </#list>
export LICENSE_PROXY_HOST=${licenseHost}
</#if>

export SHARD=${service['kundb.shards']}
if [[ -z $SHARD ]]; then
<#if service.Shard?? && service.Shard?size gt 0>
  <#assign shardNum = (service.Shard?size)>
export SHARD_NUM=${shardNum}
</#if>
else
export SHARD_NUM=$(echo $SHARD | sed 's/,/\n/g' | wc -l)
fi

if [[ -z "$LICENSE_PROXY_HOST" ]]; then
    exit 1
fi
license_proxy_server_ip=$LICENSE_PROXY_HOST
license_proxy_server_port=51000
total_shard_counts=$SHARD_NUM

SECONDS=0
TIMEOUT_SECONDS=60
until [[ $LICENSE_PROXY_READY ]]; do
    if (( $SECONDS > $TIMEOUT_SECONDS )); then
        exit 1
    fi
    cmd="curl -s -m 20 --connect-timeout 10 http://$license_proxy_server_ip:$license_proxy_server_port/license/healthCheck"
    res=$(eval $cmd)
    if [[ "$res" == "OK" ]]; then
        LICENSE_PROXY_READY="true"
    else 
        sleep 5
    fi
done

cmd="curl -s -m 20 --connect-timeout 10 http://$license_proxy_server_ip:$license_proxy_server_port/license/checkByResource?nodeNum=$total_shard_counts"
res=$(eval $cmd)

if [[ "$res" == "false" ]]; then
    exit 1
fi
