#!/bin/bash

export GUARDIAN_SERVICE_ID=${service.sid}
export CANAL_SERVER_LOG=/var/log/${service.sid}/canal-server

<#if service.auth = "kerberos">
export SECURITY_AUTH_MODE=kerberos
cp /etc/${service.sid}/conf/krb5.conf /etc/
</#if>
