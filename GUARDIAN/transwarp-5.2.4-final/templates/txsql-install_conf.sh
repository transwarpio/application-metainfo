<#assign quorums = []>
<#list service.roles["GUARDIAN_TXSQL_SERVER"]?sort_by("id") as role>
    <#assign quorums = quorums + [role.ip]>
</#list>
TxSQLNodes=(${quorums?join(' ')})

DATA_DIR=${service['data.dir']}

SQL_RW_PORT=${service['mysql.rw.port']}
BINLOG_PORT=${service['binlog.port']}
MYSQL_LOCAL_PORT=${service['mysql.local.port']}
BINLOGSVR_RPC_PORT=${service['binlogsvr.rpc.port']}
PAXOS_PORT=${service['paxos.port']}
