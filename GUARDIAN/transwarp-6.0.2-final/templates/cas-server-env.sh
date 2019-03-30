export DEBUG=1

export CAS_SERVER_UNPACK_WAR=true
export CAS_SERVER_UNPACK_DIR=/var/lib/cas-server/unpacked_war
export CAS_SERVER_TRUSTED_STORE=/srv/cas-server/trusted.keystore
export CAS_SERVER_TRUSTED_STORE_PWD=changeit

export CAS_ADMIN_SERVER_UNPACK_WAR=true
export CAS_ADMIN_SERVER_UNPACK_DIR=/var/lib/cas-admin-server/unpacked_war
export CAS_ADMIN_SERVER_TRUSTED_STORE=/srv/cas-admin-server/trusted.keystore
export CAS_ADMIN_SERVER_TRUSTED_STORE_PWD=changeit

export CAS_MGMT_SERVERNAME=https://${service.roles.CAS_ADMIN_SERVER[0]['hostname']}:${service['cas.mgmt.server.port']}

export CONFIG_SERVER_NAME=${service.roles.CAS_CONFIG_SERVER[0]['hostname']}
export CONFIG_SERVER_PORT=${service['cas.config.server.port']}
export CONFIG_USER_NAME=${service['cas.config.server.username']}
export CONFIG_USER_PASSWORD=${service['cas.config.server.password']}