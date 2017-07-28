#!/bin/bash

export HUE_DATA_DIR=/var/lib/${service.sid}
export HUE_LOG_DIR=/var/log/${service.sid}
<#if service.auth == "kerberos">
chown hue:hue /etc/${service.sid}/conf/hue.keytab
chmod 600 /etc/${service.sid}/conf/hue.keytab
cp /etc/${service.sid}/conf/krb5.conf /etc
</#if>