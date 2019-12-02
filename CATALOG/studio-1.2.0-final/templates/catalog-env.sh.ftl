#!/usr/bin/env bash
set -x
set +e
export PRINCIPAL_SUFFIX=${localhostname?lower_case}
export SQLEDITOR_SITE_PATH=/etc/${service.sid}/conf/sqleditor-site.xml
set -e