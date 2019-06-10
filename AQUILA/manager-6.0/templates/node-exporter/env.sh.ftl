#!/usr/bin/env bash

export NODE_EXPORTER_OPTS="--path.rootfs /host \
                           --web.listen-address=:${service['node.exporter.web.port']} \
                           --collector.filesystem.ignored-mount-points=${service['node.exporter.collector.filesystem.ignored-mount-points']} \
                           --collector.filesystem.ignored-fs-types=${service['node.exporter.collector.filesystem.ignored-fs-types']}"