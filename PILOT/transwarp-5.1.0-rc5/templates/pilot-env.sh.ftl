#!/bin/bash

export PILOT_EXPOSE_PORT=${service['pilot.desktop.http.port']}

<#if service.auth = "kerberos">
cp /etc/${service.sid}/conf/krb5.conf /etc/
</#if>
