#!/bin/bash

export FILEROBOT_EXPOSE_PORT=${service['filerobot.desktop.http.port']}

export FILEROBOT_EXPOSE_HOST=${service.roles.FILEROBOT_SERVER[0]['hostname']}

