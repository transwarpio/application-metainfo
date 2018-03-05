# The worker number of server
PILOT_WORKERS = ${service['pilot.server.worker.number']}

# The port of server
PILOT_WEBSERVER_PORT = ${service['pilot.desktop.http.port']}

# Maximum number of rows returned when creating slice
ROW_LIMIT = 5000

# Maximum number of rows returned in the SQL editor
SQL_MAX_ROW = 10000


# The SQLAlchemy connection string.
# Mysql database should be existed and change its charset to 'utf8':
<#assign mysqlHostPorts = []/>
<#list dependencies.TXSQL.roles['TXSQL_SERVER'] as role>
    <#assign mysqlHostPorts = mysqlHostPorts + [role.hostname + ':' + dependencies.TXSQL['mysql.rw.port']]>
</#list>
<#assign mysqlHostPort = mysqlHostPorts?join(",")>

<#assign mysqlHostPort = dependencies.TXSQL.roles.TXSQL_SERVER[0]['hostname'] + ":" + dependencies.TXSQL['mysql.rw.port']/>
<#assign username = service['javax.jdo.option.ConnectionUserName']
password = service['javax.jdo.option.ConnectionPassword']>
SQLALCHEMY_DATABASE_URI = 'mysql://${username}:${password}@${mysqlHostPort}/pilot_${service.sid}?charset=utf8'


# CAS
<#if service.auth = "kerberos">
    <#if dependencies.GUARDIAN['cas.server.ssl.port']??>
        <#assign casServerSslPort=dependencies.GUARDIAN['cas.server.ssl.port']>
        <#assign casServerName="https://${dependencies.GUARDIAN.roles.CAS_SERVER[0]['hostname']}:${casServerSslPort}">
CAS_AUTH = True
CAS_SERVER = '${casServerName}'
CAS_URL_PREFIX = '${dependencies.GUARDIAN[“cas.server.context.path”]}'
    <#else>
CAS_AUTH = False
    </#if>
</#if>


# The guardian config
GUARDIAN_AUTH = ${(service.auth = "kerberos")?string("True", "False")}


# License check
<#if dependencies.LICENSE_SERVICE??>
<#assign  license=dependencies.LICENSE_SERVICE license_servers=[]>
<#list license.roles["LICENSE_NODE"] as role>
<#assign license_servers += [(role.hostname + ":" + license[role.hostname]["zookeeper.client.port"])]>
</#list>
<#assign quorum = license_servers?join(",")>
</#if>
LICENSE_CHECK_SERVER = '${quorum}'


# Filerobot server
<#assign filerobotServer = service.roles.FILEROBOT_SERVER[0]['hostname'] + ":" + service['filerobot.desktop.http.port']>
FILE_ROBOT_SERVER = '${filerobotServer}'


# if load examples data
LOAD_EXAMPLES = ${(service['pilot.load.examples'] = "true")?string("True", "False")}


# hdfs
DEFAULT_HTTPFS = '${dependencies.HDFS.roles.HDFS_HTTPFS[0]['hostname']}'
DEFAULT_HDFS_CONN_NAME = 'default_{}'.format(DEFAULT_HTTPFS)


# Set this API key to enable Mapbox visualizations
# You need to register to mapbox.com to get the API key
# https://www.mapbox.com/developers/api/#access-tokens
MAPBOX_API_KEY = '${service['pilot.mapbox.key']}'
