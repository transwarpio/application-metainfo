#!/usr/bin/env bash

export JAVA_OPTS="-Xmx${service['heimdal.memory']?number}m -XX:+UseConcMarkSweepGC -XX:CMSInitiatingOccupancyFraction=75 -XX:+UseCMSInitiatingOccupancyOnly"