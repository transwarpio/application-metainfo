<?xml version="1.0" encoding="UTF-8" ?>
<configuration debug="true">
    <appender name="STDOUT" class="ch.qos.logback.core.ConsoleAppender">
        <encoder>
            <pattern>%d{yyyy-MM-dd HH:mm:ss.SSS} [%thread] %-5level %logger{56} - %msg%n
            </pattern>
        </encoder>
    </appender>

    <appender name="CANAL-ROOT" class="ch.qos.logback.classic.sift.SiftingAppender">
        <discriminator>
            <Key>destination</Key>
            <DefaultValue>canal-server</DefaultValue>
        </discriminator>
        <sift>
            <appender name="FILE-${r'${destination}'}" class="ch.qos.logback.core.rolling.RollingFileAppender">
                <File>${r'${CANAL_SERVER_LOG}'}/${r'${destination}'}/${r'${destination}'}.log</File>
                <rollingPolicy
                        class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
                    <!-- rollover daily -->
                    <fileNamePattern>${r'${CANAL_SERVER_LOG}'}/${r'${destination}'}/%d{yyyy-MM-dd}/${r'${destination}'}-%d{yyyy-MM-dd}-%i.log.gz</fileNamePattern>
                    <timeBasedFileNamingAndTriggeringPolicy class="ch.qos.logback.core.rolling.SizeAndTimeBasedFNATP">
                        <!-- or whenever the file size reaches 100MB -->
                        <maxFileSize>256MB</maxFileSize>
                    </timeBasedFileNamingAndTriggeringPolicy>
                    <maxHistory>10</maxHistory>
                </rollingPolicy>
                <encoder>
                    <pattern>
                        %d{yyyy-MM-dd HH:mm:ss.SSS} [%thread] %-5level %logger{56} - %msg%n
                    </pattern>
                </encoder>
            </appender>
        </sift>
    </appender>

    <appender name="CANAL-META" class="ch.qos.logback.classic.sift.SiftingAppender">
        <discriminator>
            <Key>destination</Key>
            <DefaultValue>canal</DefaultValue>
        </discriminator>
        <sift>
            <appender name="META-FILE-${r'${destination}'}" class="ch.qos.logback.core.rolling.RollingFileAppender">
                <File>${r'${CANAL_SERVER_LOG}'}/${r'${destination}'}/meta.log</File>
                <rollingPolicy
                        class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
                    <!-- rollover daily -->
                    <fileNamePattern>${r'${CANAL_SERVER_LOG}'}/${r'${destination}'}/%d{yyyy-MM-dd}/meta-%d{yyyy-MM-dd}-%i.log.gz</fileNamePattern>
                    <timeBasedFileNamingAndTriggeringPolicy class="ch.qos.logback.core.rolling.SizeAndTimeBasedFNATP">
                        <!-- or whenever the file size reaches 100MB -->
                        <maxFileSize>32MB</maxFileSize>
                    </timeBasedFileNamingAndTriggeringPolicy>
                    <maxHistory>60</maxHistory>
                </rollingPolicy>
                <encoder>
                    <pattern>
                        %d{yyyy-MM-dd HH:mm:ss.SSS} - %msg%n
                    </pattern>
                </encoder>
            </appender>
        </sift>
    </appender>

    <logger name="com.alibaba.otter.canal.server.netty" additivity="false">
        <level value="WARN" />
        <appender-ref ref="CANAL-ROOT" />
    </logger>
    <logger name="com.alibaba.otter.canal.instance" additivity="false">
        <level value="INFO" />
        <appender-ref ref="CANAL-ROOT" />
    </logger>
    <logger name="com.alibaba.otter.canal.deployer" additivity="false">
        <level value="INFO" />
        <appender-ref ref="CANAL-ROOT" />
    </logger>
    <logger name="com.alibaba.otter.canal.meta.FileMixedMetaManager" additivity="false">
        <level value="INFO" />
        <appender-ref ref="CANAL-META" />
    </logger>
    <logger name="com.alibaba.otter.canal.kafka" additivity="false">
        <level value="INFO" />
        <appender-ref ref="CANAL-ROOT" />
    </logger>

    <root level="INFO">
        <appender-ref ref="STDOUT"/>
        <appender-ref ref="CANAL-ROOT"/>
    </root>
</configuration>