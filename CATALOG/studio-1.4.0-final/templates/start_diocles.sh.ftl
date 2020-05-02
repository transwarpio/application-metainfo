<#noparse>
#!/bin/bash
set -ex

export DIOCLES_CONF_DIR=/etc/diocles/conf
cp ${CATALOG_CONF_DIR}/diocles-application.yml ${DIOCLES_CONF_DIR}/diocles-application.yml

# try use Java8 if possible
javaExec=$(which java)
ls /usr/java/jdk1.8* && \
  JAVA8_HOME=$(ls -d1 /usr/java/jdk1.8* | head -1) javaExec=${JAVA8_HOME}/bin/java || \
  echo "Java 8 is not available"

# use TCP for DNS
set +e
grep 'options use-vc' /etc/resolv.conf > /dev/null
rcode=$?
set -e
if [ $rcode -eq 1 ]; then
    echo "options use-vc" >>/etc/resolv.conf
fi

export DIOCLES_HOME=${DIOCLES_HOME:-/usr/lib/diocles}
export LOG_DIR=${LOG_DIR:-/var/log/diocles}

# check customized args
if [ X"$JAVA_D_ARGS" != X"" ]; then
    echo "JAVA_D_ARGS=${JAVA_D_ARGS}"
fi

if [ X"$JAVA_GC_ARGS" != X"" ]; then
    echo "JAVA_GC_ARGS is loaded from envionment variable: "
    echo "JAVA_GC_ARGS: $JAVA_GC_ARGS"
else
    JAVA_GC_ARGS="-XX:+UseG1GC"
    JAVA_GC_ARGS="$JAVA_GC_ARGS -XX:MaxGCPauseMillis=200"
    JAVA_GC_ARGS="$JAVA_GC_ARGS -XX:+DisableExplicitGC"
    JAVA_GC_ARGS="$JAVA_GC_ARGS -XX:+PrintGCDetails"
    JAVA_GC_ARGS="$JAVA_GC_ARGS -Xloggc:${LOG_DIR:-/var/log/diocles/gc.log}"
    JAVA_GC_ARGS="$JAVA_GC_ARGS -XX:+PrintGCApplicationStoppedTime"
    JAVA_GC_ARGS="$JAVA_GC_ARGS -XX:+PrintGCApplicationConcurrentTime"
    JAVA_GC_ARGS="$JAVA_GC_ARGS -XX:+PrintGCDateStamps"
    JAVA_GC_ARGS="$JAVA_GC_ARGS -XX:+UseGCLogFileRotation"
    JAVA_GC_ARGS="$JAVA_GC_ARGS -XX:NumberOfGCLogFiles=5"
    JAVA_GC_ARGS="$JAVA_GC_ARGS -XX:GCLogFileSize=2000k"
fi

export DEV_MODE="-Dloader.path=${DIOCLES_CONF_DIR} -Dspring.configurer.enabled=false -Dspring.bootstrap.enabled=false -Deureka.client.enabled=false -Dspring.cloud.config.enabled=false -Dspring.config.name=diocles-application  -Dspring.sleuth.enabled=false"

# start the application
exec ${javaExec} ${DEV_MODE} -cp . \
-XX:+UnlockExperimentalVMOptions \
-XX:+UseCGroupMemoryLimitForHeap \
${JAVA_D_ARGS} \
${JAVA_GC_ARGS} \
-jar ${DIOCLES_HOME}/diocles-server.jar
</#noparse>