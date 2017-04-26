import os

#---------------------------------------------------------
# Superset specific config
#---------------------------------------------------------
ROW_LIMIT = 5000	
SUPERSET_WORKERS = 4
SUPERSET_WEBSERVER_PORT = 8086
#---------------------------------------------------------

# Maximum number of rows returned in the SQL editor
SQL_MAX_ROW = 1000

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
CACHE_DEFAULT_TIMEOUT = 300
# The cache type and config
CACHE_CONFIG = {'CACHE_TYPE': 'filesystem',
                'CACHE_THRESHOLD': 200,
                'CACHE_DIR': '/tmp/pilot_cache'}

# The guardian config
GUARDIAN_HOST = '172.16.1.190'
GUARDIAN_PORT = '8080'
GUARDIAN_TIMEOUT = 5  # second


# Setup default language
BABEL_DEFAULT_LOCALE = 'zh'
# The allowed translation for you app
LANGUAGES = {
     'en': {'flag': 'us', 'name': 'English'},
    # 'fr': {'flag': 'fr', 'name': 'French'},
     'zh': {'flag': 'cn', 'name': 'Chinese'},
}



