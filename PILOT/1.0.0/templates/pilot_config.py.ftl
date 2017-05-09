import os

# The worker number of server
PILOT_WORKERS = 8
# The port of server
PILOT_WEBSERVER_PORT = ${service['pilot.desktop.http.port']}
# Maximum number of rows returned when creating slice
ROW_LIMIT = 5000
# Maximum number of rows returned in the SQL editor
SQL_MAX_ROW = 10000


DATA_DIR = os.path.join(os.path.expanduser('~'), 'pilot')
# The SQLAlchemy connection string.
#SQLALCHEMY_DATABASE_URI = 'sqlite:///' + os.path.join(DATA_DIR, 'pilot.db')
# If use mysql, the database should be existed and change its charset to 'utf8':
# 'alter database superset character set utf8'
# and  'charset=utf8' should be in uri

<#assign mysqlHostPorts = []/>
<#list dependencies.TXSQL.roles['TXSQL_SERVER'] as role>
    <#assign mysqlHostPorts = mysqlHostPorts + [role.hostname + ':' + dependencies.TXSQL['mysql.rw.port']]>
</#list>
<#assign mysqlHostPort = mysqlHostPorts?join(",")>

<#assign mysqlHostPort = dependencies.TXSQL.roles.TXSQL_SERVER[0]['hostname'] + ":" + dependencies.TXSQL['mysql.rw.port']/>
<#assign username = service['javax.jdo.option.ConnectionUserName']
password = service['javax.jdo.option.ConnectionPassword']>
#SQLALCHEMY_DATABASE_URI = 'mysql://user:password@localhost:3306/database?charset=utf8'
SQLALCHEMY_DATABASE_URI = 'mysql://${username}:${password}@${mysqlHostPort}/pilot_${service.sid}?charset=utf8'
# The lift time (seconds) of cached data
CACHE_DEFAULT_TIMEOUT = 3600
# The cache type and config
CACHE_CONFIG = {'CACHE_TYPE': 'filesystem',
                'CACHE_THRESHOLD': 500,
                'CACHE_DIR': '/tmp/pilot_cache'}

# Enable Time Rotate Log Handler
ENABLE_TIME_ROTATE = True

# The guardian config
# The guardian config
GUARDIAN_AUTH = ${(service.auth = "kerberos")?string("True", "False")}
<#if service.auth = "kerberos">
GUARDIAN_HOST = '${dependencies.GUARDIAN.roles.GUARDIAN_SERVER?sort_by("id")[0].hostname}'
GUARDIAN_PORT = '${dependencies.GUARDIAN["guardian.server.port"]}'
GUARDIAN_TIMEOUT = 5    # second
</#if>


# License check
<#assign license_servers=[]>
<#list dependencies.LICENSE_SERVICE.roles.LICENSE_NODE as server>
    <#assign license_servers += [(server.hostname + ":" + dependencies.LICENSE_SERVICE[server.hostname]["zookeeper.client.port"])]>
</#list>
LICENSE_CHECK_SERVER = '${license_servers?join(",")}'

# The jar has default path.
# if you have not moved it, then no need to changed it.
# LICENSE_CHECK_JAR = '/usr/local/lib/pilot-license.jar'

# Setup default language
BABEL_DEFAULT_LOCALE = 'zh'
# The allowed translation for you app
LANGUAGES = {
     'en': {'flag': 'us', 'name': 'English'},
    # 'fr': {'flag': 'fr', 'name': 'French'},
     'zh': {'flag': 'cn', 'name': 'Chinese'},
}
