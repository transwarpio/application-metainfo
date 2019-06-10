#!/bin/bash

<#if service.roles.SMARTBI_VERTICA??>

export SMARTBI_VERTICA_EXPOSE_HOST=${service.roles.SMARTBI_VERTICA[0]['hostname']}

export SMARTBI_VERTICA_EXPOSE_PORT=${service['smartbi.vertica.http.port']}

<#else>

export SMARTBI_VERTICA_EXPOSE_HOST=localhost

export SMARTBI_VERTICA_EXPOSE_PORT=5433

</#if>