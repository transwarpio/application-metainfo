export DEBUG=1

export UNPACK_WAR=true
export UNPACK_DIR=/var/lib/cas-server/unpacked_war

export CONFIG_SERVER_NAME=${service.roles.CAS_CONFIG_SERVER[0]['hostname']}
export CONFIG_SERVER_PORT=${service['cas.config.server.port']}
export CONFIG_USER_NAME=${service['cas.config.server.username']}
export CONFIG_USER_PASSWORD=${service['cas.config.server.password']}

export TRUSTED_STORE=/srv/cas-server/trusted.keystore
export TRUSTED_STORE_PWD=changeit