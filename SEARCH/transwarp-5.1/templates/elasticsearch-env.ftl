################################
# Elasticsearch
################################

# Elasticsearch home directory
#ES_HOME=/usr/lib/elasticsearch/elasticsearch-2.0.0-transwarp

# Elasticsearch configuration directory
#CONF_DIR=/etc/${service.sid}/conf

# Elasticsearch data directory
#DATA_DIR=${service['path.data']}

# Elasticsearch logs directory
#LOG_DIR=/var/log/${service.sid}

# Elasticsearch PID directory
#PID_DIR=/var/run/elasticsearch

# Maximum direct memory
#ES_DIRECT_SIZE=

# Additional Java OPTS
#ES_JAVA_OPTS=

# Configure restart on package upgrade (true, every other setting will lead to not restarting)
#ES_RESTART_ON_UPGRADE=true

# Path to the GC log file
#ES_GC_LOG_FILE=/var/log/elasticsearch/gc.log

################################
# Elasticsearch service
################################

# SysV init.d
#
# When executing the init script, this user will be used to run the elasticsearch service.
# The default value is 'elasticsearch' and is declared in the init.d file.
# Note that this setting is only used by the init script. If changed, make sure that
# the configured user can read and write into the data, work, plugins and log directories.
# For systemd service, the user is usually configured in file /usr/lib/systemd/system/elasticsearch.service
ES_USER=elasticsearch
ES_GROUP=elasticsearch

################################
# System properties
################################

# Specifies the maximum file descriptor number that can be opened by this process
# When using Systemd, this setting is ignored and the LimitNOFILE defined in
# /usr/lib/systemd/system/elasticsearch.service takes precedence
#MAX_OPEN_FILES=65535

# The maximum number of bytes of memory that may be locked into RAM
# Set to "unlimited" if you use the 'bootstrap.mlockall: true' option
# in elasticsearch.yml (ES_HEAP_SIZE  must also be set).
# When using Systemd, the LimitMEMLOCK property must be set
# in /usr/lib/systemd/system/elasticsearch.service
#MAX_LOCKED_MEMORY=unlimited

# Maximum number of VMA (Virtual Memory Areas) a process can own
# When using Systemd, this setting is ignored and the 'vm.max_map_count'
# property is set at boot time in /usr/lib/sysctl.d/elasticsearch.conf
MAX_MAP_COUNT=262144
