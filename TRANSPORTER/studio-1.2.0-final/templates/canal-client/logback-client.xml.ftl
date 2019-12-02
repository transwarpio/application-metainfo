<?xml version="1.0" encoding="UTF-8" ?>
<configuration debug="true">
    <!-- simple console appender -->
    <appender name="STDOUT" class="ch.qos.logback.core.ConsoleAppender">
        <encoder charset="UTF-8">
            <pattern>[%d{yyyy-MM-dd HH:mm:ss.SSS}] %highlight(%-5level) %cyan(%logger{36}) - %msg%n</pattern>
        </encoder>
    </appender>
    <!-- rolling file appender -->
    <appender name="CLIENT-ROOT" class="ch.qos.logback.classic.sift.SiftingAppender">
        <discriminator>
            <Key>adapter</Key>
            <DefaultValue>canal-client</DefaultValue>
        </discriminator>
        <sift>
            <appender name="FILE-${r'${adapter}'}" class="ch.qos.logback.core.rolling.RollingFileAppender">
                <File>${r'${CANAL_CLIENT_LOG}'}/${r'${adapter}'}/${r'${adapter}'}.log</File>
                <rollingPolicy
                        class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
                    <!-- rollover daily -->
                    <fileNamePattern>${r'${CANAL_CLIENT_LOG}'}/${r'${adapter}'}/%d{yyyy-MM-dd}/${r'${adapter}'}-%d{yyyy-MM-dd}-%i.log.gz</fileNamePattern>
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

    <root level="INFO">
        <appender-ref ref="STDOUT"/>
        <appender-ref ref="CLIENT-ROOT"/>
    </root>
</configuration>