#!/bin/bash

export SMARTBI_MYSQL_EXPOSE_HOST=${service.roles.SMARTBI_MYSQL[0]['hostname']}

export SMARTBI_MYSQL_EXPOSE_PORT=${service['pilotenterprise.mysql.http.port']}
