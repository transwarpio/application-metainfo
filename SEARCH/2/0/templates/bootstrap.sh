#!/bin/bash

[ -f /external/scripts/init.sh ] && {
  . /external/scripts/init.sh
}

usage()
{
  echo "usage:" 
  echo "$(basename $0)" 
  echo "Environment : " 
  echo -e "\t \$DEBUG : wait for debug when docker exiting" 
}

source $ES_SCRIPTS_PATH/tdh-env.sh
source $ES_SCRIPTS_PATH/repeat_until_ready.sh
# source the default env file
ES_ENV_FILE="$CONF_DIR/elasticsearch-env"
if [ -f "$ES_ENV_FILE" ]; then
    . "$ES_ENV_FILE"
fi

[ $# -gt 1 ] && {
  usage
  exit 1
}

replace()
{
  # $1: source string
  # $2: target string
  # $3: file
  local src="$1"
  local target="$2"
  local file="$3"
  target=${target//\//\\/}
  sed -i s/"$src"/"$target"/g "$file"  
}

handleElasticConf() 
{
  # copy the ik and mmseg config file
  local ES_IK_DIR="$CONF_DIR/ik"
  if [ -d "$ES_IK_DIR" ]; then
    rm -rf "$ES_IK_DIR"
  fi
  cp -r "$ES_HOME/config/ik" "$CONF_DIR"

  local ES_MMSEG_DIR="$CONF_DIR/mmseg"
  if [ -d "$ES_MMSEG_DIR" ]; then
    rm -rf "$ES_MMSEG_DIR"
  fi
  cp -r "$ES_HOME/config/mmseg" "$CONF_DIR"
}

prepareStartScript()
{
  local ES_START_SCRIPT="$ES_SCRIPTS_PATH/elasticsearch-transwarp"
  if [ -f "$ES_START_SCRIPT" ]; then
    cp "$ES_START_SCRIPT" "/etc/init.d/"
    chmod 755 "/etc/init.d/elasticsearch-transwarp"
  else
    echo "the elasticsearch start script does not exist !"
    exit 1
  fi
}

handleFolderPermission()
{
  for dir in $LOG_DIR $CONF_DIR `echo $DATA_DIR | sed 's/,/ /g'`
  do
    [ -d $dir ] || mkdir -p $dir
    chown -R elasticsearch:elasticsearch $dir
    chmod -R 755 $dir
  done
}

startElasticsearch()
{
  local scriptPath="/etc/init.d/elasticsearch-transwarp"
  sed -i "s@CONF_DIR=.*@CONF_DIR=${CONF_DIR}@" $scriptPath
  "$scriptPath" start
}

# preparation
handleElasticConf
prepareStartScript
handleFolderPermission

# start elasticsearch
startElasticsearch

