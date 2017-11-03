#!/bin/bash

usage()
{
  echo "usage:"
  echo "$(basename $0) KAFKA_SERVER: start KAFKA_SERVER"
}

set -x

export TDH_SCRIPT_DIR=/bin/transwarp

echo 'umount /etc/hosts'
umount /etc/hosts
echo 'rm -rf /etc/hosts'
rm -rf /etc/hosts
echo 'ln -s /etc/transwarp/conf/hosts /etc/'
ln -s /etc/transwarp/conf/hosts /etc/

DEBUG=${DEBUG:-0}

[ $# -eq 0 ] && {
  usage
  exit 1
}

create_change_dirs_permision(){
  IFS=','
  tmp=($2)
  for dir in ${tmp[@]};do
    [ -d $dir ] || mkdir -p $dir
    chown -R $1 $dir
    chmod -R 755 $dir
  done
}

export KAFKA_CONF_DIR=${KAFKA_CONF_DIR:-/etc/kafka/conf}

KAFKA_ENV=$KAFKA_CONF_DIR/kafka-env.sh
[ -f $KAFKA_ENV ] && {
  source $KAFKA_ENV
}

KAFKA_USER=root

create_change_dirs_permision $KAFKA_USER:$KAFKA_USER "${KAFKA_DATA_DIRS}"
create_change_dirs_permision $KAFKA_USER:$KAFKA_USER "${KAFKA_LOG_DIR}"

BROKER_ID_FILE="/data/dnsha.conf"
if [[ "${BROKER_ID_EQUALS_TO_DND_ID}" != "true" ]]; then
  BROKER_ID="${REPLICATION_JOB_ID}"
elif [[ -f "${BROKER_ID_FILE}" ]]; then
  source "${BROKER_ID_FILE}"
  if [[ -z "${DNS_ID}" ]]; then
    echo "Failed to read DNS_ID from ${BROKER_ID_FILE}"
    exit 1
  else
    BROKER_ID="${DNS_ID}"
  fi
else
  echo "Could not find DNS_ID file ${BROKER_ID_FILE}"
  exit 1
fi

until [ $# -eq 0 ]
do
  echo "starting $1"
  case $1 in
    KAFKA_SERVER )
      $TDH_SCRIPT_DIR/kafka-start.sh
    ;;
    * )
      usage
      exit 1
    ;;
  esac
  shift 1
done

[ $DEBUG -eq 1 ] && {
  echo "Waiting for debug before exit"
  while true
  do
    sleep 10
  done
}
