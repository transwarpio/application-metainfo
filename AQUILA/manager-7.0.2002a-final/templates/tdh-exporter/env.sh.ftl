#!/usr/bin/env bash

export EXPORTER_JAVA_OPTS="-Xmx${service['tdh.exporter.memory']?number}m -XX:+UseConcMarkSweepGC -XX:CMSInitiatingOccupancyFraction=75 -XX:+UseCMSInitiatingOccupancyOnly"