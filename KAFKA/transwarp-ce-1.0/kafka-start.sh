ARGS="daemon kafkaServer kafka.Kafka ${KAFKA_CONF_DIR}/server.properties"

CLASSPATH=""
for jar in `find /usr/lib/kafka -name "*.jar"`
do
   CLASSPATH+=":$jar"
done

JAVA_OPTS="-Xmx1G \
-Xms1G \
-XX:+UseCompressedOops \
-XX:+UseParNewGC \
-XX:+UseConcMarkSweepGC \
-XX:+CMSClassUnloadingEnabled \
-XX:+CMSScavengeBeforeRemark \
-XX:+DisableExplicitGC \
-Djava.awt.headless=true \
-Xloggc:${KAFKA_LOG_DIR}/kafkaServer-gc.log \
-verbose:gc \
-XX:+PrintGCDetails \
-XX:+PrintGCDateStamps \
-XX:+PrintGCTimeStamps \
-Dcom.sun.management.jmxremot \
-Dcom.sun.management.jmxremote.authenticate=false \
-Dcom.sun.management.jmxremote.ssl=false \
-Dcom.sun.management.jmxremote.port=${KAFKA_JMX_REMOTE_PORT} \
-Dlog4j.configuration=file:/usr/lib/kafka/bin/../config/log4j.properties \
-Dkafka.log.fullpath=${KAFKA_LOG_DIR}/kafka-server.log"

$JAVA_HOME/bin/java $JAVA_OPTS $KRB_OPTS -cp $CLASSPATH kafka.Kafka ${KAFKA_CONF_DIR}/server.properties
