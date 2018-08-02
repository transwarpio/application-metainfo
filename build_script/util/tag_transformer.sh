#!/usr/bin/env bash

IN_PROGRESS_VERSION=sophonweb-1.3
TAG_VERSION=sophonweb-2.0

set -e

SCRIPT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
WORKSPACE="${SCRIPT_DIR}/../.."

for service_dir in "${WORKSPACE}"/*; do
    if [ -d "${service_dir}/${IN_PROGRESS_VERSION}" ]; then
        rm -rf "${service_dir}/${TAG_VERSION}"
        \cp -rp "${service_dir}/${IN_PROGRESS_VERSION}" "${service_dir}/${TAG_VERSION}"
        for file in $(find "${service_dir}/${TAG_VERSION}" | grep -v upgrade); do
            if [ -f ${file} ]; then
                sed -i "s/${IN_PROGRESS_VERSION}/${TAG_VERSION}/g" "${file}"
            fi
        done
    fi
done
