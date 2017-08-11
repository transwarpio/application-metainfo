log4j.rootLogger=INFO, console, RFA

log4j.appender.console=org.apache.log4j.ConsoleAppender
log4j.appender.console.target=System.err
log4j.appender.console.layout=org.apache.log4j.PatternLayout
log4j.appender.console.layout.ConversionPattern=%d{yy/MM/dd HH:mm:ss} %p %c{2}: %m%n
#log4j.logger.io.transwarp.studio.persistence.mapper.cubedesigner=TRACE
layout.conversion.pattern=%d %5p %c: %X{akkaSource} [%X{sourceThread} %t] (%F:%L) - %m%n



log4j.appender.RFA=org.apache.log4j.RollingFileAppender
log4j.appender.RFA.File=/var/log/${service.sid}/rubik.log

# Logfile size and and 30-day backups
log4j.appender.RFA.MaxFileSize=5MB
log4j.appender.RFA.MaxBackupIndex=7

log4j.appender.RFA.layout=org.apache.log4j.PatternLayout
log4j.appender.RFA.layout.ConversionPattern=%d{ISO8601} %-5p %c{2} (%F:%M(%L)) - %m%n
