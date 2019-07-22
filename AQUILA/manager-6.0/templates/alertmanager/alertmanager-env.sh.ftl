#!/usr/bin/env bash
export ALERTMANAGER_OPTS="--config.file=/etc/${service.sid}/conf/alertmanager/alertmanager.yml \
                        --web.listen-address=:${service['alertmanager.web.port']} \
                        "