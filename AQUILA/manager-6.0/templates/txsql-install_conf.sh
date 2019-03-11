<#assign quorums = []>
<#list service.roles["AQUILA_TXSQL_SERVER"]?sort_by("id") as role>
    <#assign quorums = quorums + [role.ip]>
</#list>
TxSQLNodes=(${quorums?join(' ')})

DATA_DIR=${service['txsql.data.dir']}

SQL_RW_PORT=${service['txsql.mysql.rw.port']}
BINLOG_PORT=${service['txsql.binlog.port']}
MYSQL_LOCAL_PORT=${service['txsql.mysql.local.port']}
BINLOGSVR_RPC_PORT=${service['txsql.binlogsvr.rpc.port']}
PAXOS_PORT=${service['txsql.paxos.port']}
