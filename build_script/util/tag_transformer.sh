#!/usr/bin/env bash

MANAGER_PROGRESS_VERSION=manager-6.0
MANAGER_TAG_VERSION=manager-6.0.1811a-final
LAST_STABLE_VERSION=transwarp-6.0.0-final
TDH_PROGRESS_VERSION=transwarp-6.0
TDH_TAG_VERSION=transwarp-6.0.1-final

set -e

SCRIPT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
WORKSPACE="${SCRIPT_DIR}/../.."
RELEASE_DATE_FILE="${WORKSPACE}/release-date.csv"

rm -f "${RELEASE_DATE_FILE}"
for service_dir in "${WORKSPACE}"/*; do
    if [ -d "${service_dir}/${MANAGER_PROGRESS_VERSION}" ]; then
        rm -rf "${service_dir}/${MANAGER_TAG_VERSION}"
        \cp -rp "${service_dir}/${MANAGER_PROGRESS_VERSION}" "${service_dir}/${MANAGER_TAG_VERSION}"
        for file in $(find "${service_dir}/${MANAGER_TAG_VERSION}" | grep -v upgrade); do
            if [ -f ${file} ]; then
                sed -i "s/${MANAGER_PROGRESS_VERSION}/${MANAGER_TAG_VERSION}/g" "${file}"
                sed -i "s/${LAST_STABLE_VERSION}/${TDH_TAG_VERSION}/g" "${file}"
            fi
        done
    fi

    if [ -d "${service_dir}/${TDH_PROGRESS_VERSION}" ]; then
        rm -rf "${service_dir}/${TDH_TAG_VERSION}"
        \cp -rp "${service_dir}/${TDH_PROGRESS_VERSION}" "${service_dir}/${TDH_TAG_VERSION}"
        for file in $(find "${service_dir}/${TDH_TAG_VERSION}" | grep -v upgrade); do
            if [ -f ${file} ]; then
                sed -i "s/${TDH_PROGRESS_VERSION}/${TDH_TAG_VERSION}/g" "${file}"
            fi
        done
    fi


    for version_dir in "$service_dir"/*; do
        if [ -e "${version_dir}/metainfo.yaml" ]; then
            cd "${version_dir}";
            if release_date=$(git log -1 --format='%at' -- .) && [ ! -z "${release_date}" ]; then
                echo $(basename "${service_dir}"),$(basename "${version_dir}"),${release_date} >> "${RELEASE_DATE_FILE}"
            fi
            cd - >/dev/null
        fi
    done
done
