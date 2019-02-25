#!/usr/bin/env bash

IN_PROGRESS_VERSION=sophon-2.2
TAG_VERSION=sophon-2.2.0-rc1
set -e

SCRIPT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
WORKSPACE="${SCRIPT_DIR}/../.."

SERVICE_LIST=(SOPHON IOT SOPHON_ST)

for service in "${SERVICE_LIST[@]}"; do
    if [ -d "${WORKSPACE}"/"${service}"/"${IN_PROGRESS_VERSION}" ]; then
       rm -rf "${WORKSPACE}"/"${service}"/"${TAG_VERSION}"
       cp -rp "${WORKSPACE}"/"${service}"/"${IN_PROGRESS_VERSION}" "${WORKSPACE}"/"${service}"/"${TAG_VERSION}"
       for file in $(find "${WORKSPACE}"/"${service}"/"${TAG_VERSION}" | grep -v upgrade | grep -v metainfo.yaml); do
           if [ -f ${file} ]; then
              sed -i "s/${IN_PROGRESS_VERSION}/${TAG_VERSION}/g" "${file}"
           fi
       done
       sed -i "s/version: ${IN_PROGRESS_VERSION}/version: ${TAG_VERSION}/" "${WORKSPACE}"/"${service}"/"${TAG_VERSION}"/metainfo.yaml
       sed -i "/dockerImage/s#${IN_PROGRESS_VERSION}#${TAG_VERSION}#" "${WORKSPACE}"/"${service}"/"${TAG_VERSION}"/metainfo.yaml
    fi
done

