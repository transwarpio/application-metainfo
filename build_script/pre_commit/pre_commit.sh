#!/usr/bin/env bash

SUPPORTED_VERSIONS=(transwarp-5.1 transwarp-5.0 transwarp-ce-1.0)
VIRTUAL_MACHINES=(172.16.1.1:172.16.1.249 172.16.1.2:172.16.1.250 172.16.1.4:172.16.1.251)
MANAGER_IP=172.16.1.251
MANAGER_PORT=8180


set -e

SCRIPT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

print_merge_params() {
    echo "=================================================="
    echo "gitlabActionType : ${gitlabActionType}"
    echo "gitlabBranch : ${gitlabBranch}"
    echo "gitlabMergeRequestId : ${gitlabMergeRequestId}"
    echo "gitlabMergeRequestIid : ${gitlabMergeRequestIid}"
    echo "gitlabMergeRequestLastCommit : ${gitlabMergeRequestLastCommit}"
    echo "gitlabMergeRequestTitle : ${gitlabMergeRequestTitle}"
    echo "gitlabSourceBranch : ${gitlabSourceBranch}"
    echo "gitlabSourceNamespace : ${gitlabSourceNamespace}"
    echo "gitlabSourceRepoHomepage : ${gitlabSourceRepoHomepage}"
    echo "gitlabSourceRepoHttpUrl : ${gitlabSourceRepoHttpUrl}"
    echo "gitlabSourceRepoName : ${gitlabSourceRepoName}"
    echo "gitlabSourceRepoSshUrl : ${gitlabSourceRepoSshUrl}"
    echo "gitlabSourceRepoURL : ${gitlabSourceRepoURL}"
    echo "gitlabTargetBranch : ${gitlabTargetBranch}"
    echo "gitlabTargetNamespace : ${gitlabTargetNamespace}"
    echo "gitlabTargetRepoHttpUrl : ${gitlabTargetRepoHttpUrl}"
    echo "gitlabTargetRepoName : ${gitlabTargetRepoName}"
    echo "gitlabTargetRepoSshUrl : ${gitlabTargetRepoSshUrl}"
    echo "gitlabUserEmail : ${gitlabUserEmail}"
    echo "gitlabUserName : ${gitlabUserName}"
    echo "=========================================================="
}


pull_merge_request() {
    local temp_branch=${gitlabSourceNamespace}/${gitlabSourceRepoName}-${gitlabSourceBranch}

    git fetch ${gitlabSourceRepoHttpUrl} ${gitlabSourceBranch}
    git checkout -b ${temp_branch} FETCH_HEAD

    git checkout ${gitlabTargetBranch}
    git merge --no-ff ${temp_branch} --no-edit
}

# exported: AFFECTED_VERSIONS
calc_affected_versions() {
    AFFECTED_VERSIONS=()
    for version in "${SUPPORTED_VERSIONS[@]}"; do
        if git diff origin/${gitlabTargetBranch} | grep ${version} ; then
            AFFECTED_VERSIONS+=(${version})
        fi
    done
}


calc_affected_services() {
    current_version=$1

    affected_services=$(git diff origin/${gitlabTargetBranch} | perl -nle 'm\ [ab]/([^/]*)/'${current_version}'/\; print $1' | sort | uniq)
}


revert_virtual_machines() {
    current_version=$1

    for host_guest in "${VIRTUAL_MACHINES[@]}"; do
        host_ip=$(echo ${host_guest} | cut -d':' -f1)
        guest_ip=$(echo ${host_guest} | cut -d':' -f2)
        guest_id="cloudservice_${guest_ip}_centos72"

        set +e
        ssh -o StrictHostKeyChecking=no ${host_ip} virsh destroy ${guest_id}
        set -e
        ssh -o StrictHostKeyChecking=no ${host_ip} virsh snapshot-revert ${guest_id} ${current_version}
        ssh -o StrictHostKeyChecking=no ${host_ip} virsh start ${guest_id}

        for i in {1..60}; do
            if ping -c 1 -w 2 ${guest_ip}; then
                break
            fi
            sleep 1
        done
        if ! ping -c 1 -w 2 ${guest_ip}; then
            exit 1
        fi
    done
}





print_merge_params

pull_merge_request

calc_affected_versions
echo "affected versions: ${AFFECTED_VERSIONS[@]}"

for version in "${AFFECTED_VERSIONS[@]}"; do
    echo "# testing $version ..."
    calc_affected_services "$version"
    echo "modified services: ${affected_services}"
    start_sequence=$(python "${SCRIPT_DIR}/util/get_sorted_releted_services.py" "${WORKSPACE}" ${version} ${affected_services})
    echo "start sequence: ${start_sequence}"

    revert_virtual_machines ${version}
done
