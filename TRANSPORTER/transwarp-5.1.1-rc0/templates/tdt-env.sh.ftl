#!/bin/bash

export GUARDIAN_SERVICE_ID=${service.sid}
export TDT_LOG_DIR=/var/log/${service.sid}

<#if service.auth = "kerberos">
cp /etc/${service.sid}/conf/krb5.conf /etc/
</#if>
