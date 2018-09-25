## JVM configuration

################################################################
## IMPORTANT: JVM heap size
################################################################
##
## You should always set the min and max JVM heap
## size to the same value. For example, to set
## the heap to 4 GB, set:
##
## -Xms4g
## -Xmx4g
##
## See https://www.elastic.co/guide/en/elasticsearch/reference/current/heap-size.html
## for more information
##
################################################################

# Xms represents the initial size of total heap space
# Xmx represents the maximum size of total heap space
# Xmn represents the maximum size of young genernation heap space

<#if service['search.container.limits.memory'] != "-1" && service['search.memory.ratio'] != "-1">
  <#assign limitsMemory = service['search.container.limits.memory']?number
  memoryRatio = service['search.memory.ratio']?number
  searchMemory = limitsMemory * memoryRatio * 1024>
<#else>
  <#if service[.data_model["localhostname"]]['es.heap.size']??>
    <#assign searchMemory=service[.data_model["localhostname"]]['es.heap.size']?trim?number>
  <#else>
    <#assign searchMemory=30720>
  </#if>
</#if>

-Xms${searchMemory?floor}m
-Xmx${searchMemory?floor}m
-Xmn${(searchMemory/4)?floor}m

#-XX:MaxDirectMemorySize=${searchMemory?floor}m

################################################################
## Expert settings
################################################################
##
## All settings below this section are considered
## expert settings. Don't tamper with them unless
## you understand what you are doing
##
################################################################

## GC configuration
-XX:+UseConcMarkSweepGC
-XX:CMSInitiatingOccupancyFraction=75
-XX:+UseCMSInitiatingOccupancyOnly
-XX:SurvivorRatio=2

## optimizations

# disable calls to System#gc
-XX:+DisableExplicitGC

# pre-touch memory pages used by the JVM during initialization
-XX:+AlwaysPreTouch

## basic

# force the server VM (remove on 32-bit client JVMs)
-server

# explicitly set the stack size (reduce to 320k on 32-bit client JVMs)
-Xss1m

# set to headless, just in case
-Djava.awt.headless=true

# ensure UTF-8 encoding by default (e.g. filenames)
-Dfile.encoding=UTF-8

# use our provided JNA always versus the system one
-Djna.nosys=true

# use old-style file permissions on JDK9
-Djdk.io.permissionsUseCanonicalPath=true

# flags to configure Netty
-Dio.netty.noUnsafe=true
-Dio.netty.noKeySetOptimization=true
-Dio.netty.recycler.maxCapacityPerThread=0

# log4j 2
-Dlog4j.shutdownHookEnabled=false
-Dlog4j2.disable.jmx=true
-Dlog4j.skipJansi=true

## heap dumps

# generate a heap dump when an allocation from the Java heap fails
# heap dumps are created in the working directory of the JVM
-XX:+HeapDumpOnOutOfMemoryError

# specify an alternative path for heap dumps
# ensure the directory exists and has sufficient space
#-XX:HeapDumpPath=$HEAP_DUMP_PATH

## GC logging

#-XX:+PrintGCDetails
#-XX:+PrintGCTimeStamps
#-XX:+PrintGCDateStamps
#-XX:+PrintClassHistogram
#-XX:+PrintTenuringDistribution
#-XX:+PrintGCApplicationStoppedTime

# log GC status to a file with time stamps
# ensure the directory exists
#-Xloggc:$LOGGC

# By default, the GC log file will not rotate.
# By uncommenting the lines below, the GC log file
# will be rotated every 128MB at most 32 times.
#-XX:+UseGCLogFileRotation
#-XX:NumberOfGCLogFiles=32
#-XX:GCLogFileSize=128M

# Elasticsearch 5.0.0 will throw an exception on unquoted field names in JSON.
# If documents were already indexed with unquoted fields in a previous version
# of Elasticsearch, some operations may throw errors.
#
# WARNING: This option will be removed in Elasticsearch 6.0.0 and is provided
# only for migration purposes.
#-Delasticsearch.json.allow_unquoted_field_names=true

# Force use IPv4
-Djava.net.preferIPv4Stack=true

# For JMX monitoring
#-Dcom.sun.management.jmxremote
#-Dcom.sun.management.jmxremote.port=1818
#-Dcom.sun.management.jmxremote.authenticate=false
#-Dcom.sun.management.jmxremote.ssl=false
#-Dcom.sun.management.jmxremote.local.only=false

# For remote debugging
#-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=5006
