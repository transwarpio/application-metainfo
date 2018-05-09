<#assign mysql_port=service['mysql.port']>
[client]
port      = ${mysql_port}
socket    = /var/transwarp/run/inceptormysql.sock
default-character-set = utf8

[mysqld_safe]
socket    = /var/transwarp/run/inceptormysql.sock
nice      = 0

[mysqld]
user      = mysql
socket    = /var/transwarp/run/inceptormysql.sock
port      = ${mysql_port}
basedir   = /usr
datadir   = /var/transwarp/data/mysql
log-bin   = mysql-bin
tmpdir    = /var/transwarp/tmp
skip-external-locking
bind-address       = 0.0.0.0
key_buffer         = 16M
max_allowed_packet = 16M
thread_stack       = 192K
thread_cache_size  = 8
myisam-recover     = BACKUP
query_cache_limit  = 1M
query_cache_size   = 16M
log_error          = /var/transwarp/logs/mysqld.log
expire_logs_days   = 10
max_binlog_size    = 100M
binlog_format      = mixed
character_set_server = utf8

[mysqldump]
quick
quote-names
max_allowed_packet = 16M

[mysql]

[isamchk]
key_buffer    = 16M
!includedir /etc/mysql/conf.d/
