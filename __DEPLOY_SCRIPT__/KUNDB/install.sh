#!/usr/bin/env bash

set -e

#parse parameter
for opt in "$@"; do
  case $opt in
    --FTP_DIR=*) FTP_DIR=${opt#*=}; shift;;
    --META_DIR=*) META_DIR=${opt#*=}; shift;;
    --TDH_CLIENT_DIR=*) TDH_CLIENT_DIR=${opt#*=}; shift;;
    --TDH_PLUGIN_DIR=*) TDH_PLUGIN_DIR=${opt#*=}; shift;;
    *) echo "Ignore unsupport argument: '$opt'.";;
  esac
done

if [ -z "$FTP_DIR" ] || [ -z "$META_DIR" ] || [ -z "$TDH_CLIENT_DIR" ] || [ -z "$TDH_PLUGIN_DIR" ];
then
    echo "USAGE:
    ./install.sh --FTP_DIR=... --META_DIR==... --TDH_CLIENT_DIR=... --TDH_PLUGIN_DIR=..."
    exit 1
fi

umask 0022

current_dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

function copy_files {

echo "copy service clients ..."

    if [ ! -d $FTP_DIR/service_client ]; then
        mkdir -p $FTP_DIR/service_client
    fi
    \cp -rpf $current_dir/../service_client/* $FTP_DIR/service_client

    if [ ! -d $META_DIR ]; then
        mkdir -p $META_DIR
    fi
    \cp -rpf $current_dir/../service_meta/. $META_DIR
}

copy_files
