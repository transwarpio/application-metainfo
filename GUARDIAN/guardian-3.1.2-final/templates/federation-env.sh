<#assign hostPorts = []>
<#list service.roles["GUARDIAN_TXSQL_SERVER"] as r>
    <#assign hostPorts = hostPorts + [r.hostname + ':' + service['mysql.rw.port']]>
</#list>
export TXSQL_SERVERS=${hostPorts?join(",")}
export MYSQL_DATABASE=federation
export FEDERATION_SERVICE_DATASOURCE_USERNAME=root
export FEDERATION_SERVICE_DATASOURCE_PASSWORD=${service['root.password']}
export FEDERATION_SERVICE_DATASOURCE_DRIVER_CLASS=${service['guardian.database.driver']}

export JAVA_OPTS=" $JAVA_OPTS -Xms1024m -Xmx2048m -XX:MaxPermSize=128m -XX:+UseConcMarkSweepGC -XX:+PrintGCDetails -XX:+PrintGCDateStamps -Xloggc:$GUARDIAN_LOG_DIR/guardian-server_gc.log -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=$GUARDIAN_LOG_DIR "

export SERVER_PORT=${service['federation.server.port']}

export FEDERATION_SERVICE_SESSION_TIMEOUT=${service['federation.service.session.timeout']}

export FEDERATION_SERVICE_SSL_ENABLED=true
export FEDERATION_SERVICE_SSL_KEY_STORE=/srv/federation/server.keystore
export FEDERATION_SERVICE_SSL_KEY_STORE_PASSWORD=changeit

export FEDERATION_SERVICE_SESSION_ENABLE_SHARING=${service['federation.service.session.enableSharing']}
export FEDERATION_SERVICE_SESSION_EXPIRE_MODE=${service['federation.service.session.expireMode']}
export FEDERATION_SERVICE_SESSION_MAX_INACTIVE_INTERVAL=${service['federation.service.session.maxInactiveInterval']}
export FEDERATION_SERVICE_EXPIRED_SESSION_EVICTION_START_DELAY=${service['federation.service.session.expiredSessionEvictionStartDelay']}
export FEDERATION_SERVICE_EXPIRED_SESSION_EVICTION_INTERVAL=${service['federation.service.session.expiredSessionEvictionInterval']}
export FEDERATION_SERVICE_SESSION_CACHE_EVICTION_INTERVAL=${service['federation.service.session.sessionCacheEvictionInterval']}

export FEDERATION_SERVICE_RESET_PASSWORD_ALLOWED=${service['federation.service.resetPasswordAllowed']}

export FEDERATION_SERVICE_USER_ADMIN_PASSWORD=${service['federation.service.user.admin.password']}
export FEDERATION_SERVICE_USER_ADMIN_USE_PLAIN_PASSWORD=${service['federation.service.user.admin.usePlainPassword']}
export FEDERATION_SERVICE_USER_AUTH_CACHE_ENABLED=${service['federation.service.user.auth.cache.enabled']}
export FEDERATION_SERVICE_USER_AUTH_CACHE_MAXIMUM_SIZE=${service['federation.service.user.auth.cache.maximumSize']}
export FEDERATION_SERVICE_USER_AUTH_CACHE_EXPIRE_AFTER_ACCESS=${service['federation.service.user.auth.cache.expireAfterAccess']}
export FEDERATION_SERVICE_USER_AUTH_CACHE_EXPIRE_AFTER_WRITE=${service['federation.service.user.auth.cache.expireAfterWrite']}

export FEDERATION_OAUTH2_CLIENT_ACCESS_TOKEN_VALIDITY_SECONDS=${service['federation.oauth2.client.accessTokenValiditySeconds']}
export FEDERATION_OAUTH2_CLIENT_REFRESH_TOKEN_VALIDITY_SECONDS=${service['federation.oauth2.client.refreshTokenValiditySeconds']}
export FEDERATION_OAUTH2_CLIENT_AUTH_CACHE_ENABLED=${service['federation.oauth2.client.auth.cache.enabled']}
export FEDERATION_OAUTH2_CLIENT_AUTH_CACHE_MAXIMUM_SIZE=${service['federation.oauth2.client.auth.cache.maximumSize']}
export FEDERATION_OAUTH2_CLIENT_AUTH_CACHE_EXPIRE_AFTER_ACCESS=${service['federation.oauth2.client.auth.cache.expireAfterAccess']}
export FEDERATION_OAUTH2_CLIENT_AUTH_CACHE_EXPIRE_AFTER_WRITE=${service['federation.oauth2.client.auth.cache.expireAfterWrite']}

export FEDERATION_OAUTH2_LOGOUT_FOLLOW_CLIENT_REDIRECT=${service['federation.oauth2.logout.followClientRedirect']}
export FEDERATION_OAUTH2_LOGOUT_VALIDATE_BEFORE_REDIRECT=${service['federation.oauth2.logout.validateBeforeRedirect']}

export OAUTH2_TOKEN_EVICTION_ENABLED=${service['federation.oauth2.tokenEviction.enabled']}
export OAUTH2_TOKEN_EVICTION_START_DELAY=${service['federation.oauth2.tokenEviction.startDelay']}
export OAUTH2_TOKEN_EVICTION_REPEAT_INTERVAL=${service['federation.oauth2.tokenEviction.repeatInterval']}

export OAUTH2_TOKEN_REFRESH_START_DELAY=${service['federation.oauth2.tokenRefresh.startDelay']}
export OAUTH2_TOKEN_REFRESH_REPEAT_INTERVAL=${service['federation.oauth2.tokenRefresh.repeatInterval']}

export OAUTH2_LOGIN_TENANT_NAME_AUTO_FILLED=${service['federation.oauth2.login.tenantNameAutoFilled']}
export HA_LEADER_ELECTION_NODE_STATUS_UPDATE_INITIAL_DELAY=${service['ha.leader-election.nodeStatusUpdate.initialDelay']}
export HA_LEADER_ELECTION_NODE_STATUS_UPDATE_INTERVAL=${service['ha.leader-election.nodeStatusUpdate.interval']}
export HA_LEADER_ELECTION_TIME_TO_OVERTHROW_DORMANT_LEADER=${service['ha.leader-election.timeToOverthrowDormantLeader']}

export FEDERATION_SERVICE_CAPTCHA_ENABLED=${service['federation.service.captcha.enabled']}
export FEDERATION_SERVICE_CAPTCHA_COOKIE_HTTP_ONLY=${service['federation.service.captcha.cookie.httpOnly']}
export FEDERATION_SERVICE_CAPTCHA_COOKIE_MAX_AGE=${service['federation.service.captcha.cookie.maxAge']}
export FEDERATION_SERVICE_CAPTCHA_COOKIE_CHECK_EXPIRY=${service['federation.service.captcha.cookie.checkExpiry']}

export FEDERATION_LOG_LEVEL=${service['federation.service.log.level']}
