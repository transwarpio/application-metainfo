#!/bin/bash

usage()
{
  echo "usage:"
  echo "role: master | slave"
  echo "ip: ip address of node"
  echo "eg: health_check.sh master 127.0.0.1"
}

if [ $# -ne 2 ]; then
  usage
  exit 1
fi

node_ip=$2
case $1 in
  master )
    apiserver_status=`curl ${node_ip}:8080/healthz`
    if [ "${apiserver_status}" != "ok" ];then
      echo "failed"
      exit 1
    fi
    scheduler_status=`curl ${node_ip}:10251/healthz`
    if [ "${scheduler_status}" != "ok" ];then
      echo "failed"
      exit 1
    fi
    controller_status=`curl ${node_ip}:10252/healthz`
    if [ "${controller_status}" != "ok" ];then
      echo "failed"
      exit 1
    fi
    etcd_status=`curl ${node_ip}:4001/health`
    if [ "${etcd_status}" != "{\"health\": \"true\"}" ];then
      echo "failed"
      exit 1
    fi
  ;;
  slave )
    kubelet_status=`curl ${node_ip}:10255/healthz`
    if [ "${kubelet_status}" != "ok" ];then
      echo "failed"
      exit 1
    fi
  ;;
  * )
    usage
    exit 1
esac
echo "running"
exit 0
