#!/usr/bin/env bash

SUPPORTED_VERSIONS=(transwarp-5.1 transwarp-5.0 transwarp-ce-1.0)
VIRTUAL_MACHINES=(172.16.1.1:172.16.1.249 172.16.1.2:172.16.1.250 172.16.1.4:172.16.1.251)
MANAGER_IP=172.16.1.251
MANAGER_PORT=8180
MANAGER_USER=admin
MANAGER_PASS=admin
CLUSTER_ID=1

SLEEP_SECONDS=3
MAX_TIMES=1000
MAX_RETRY=5

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
        ssh ${host_ip} virsh destroy ${guest_id}
        set -e
        ssh ${host_ip} virsh snapshot-revert ${guest_id} ${current_version}
        ssh ${host_ip} virsh start ${guest_id}

        for i in {1..60}; do
            if ssh ${guest_ip} hostname; then
                break
            fi
            sleep 1
        done
        if ! ssh ${guest_ip} hostname; then
            exit 1
        fi
    done
}


update_meta() {
    ssh ${MANAGER_IP} /etc/init.d/transwarp-manager stop
    ssh ${MANAGER_IP} rm -rf /var/lib/transwarp-manager/master/content/meta/services/*
    echo "Updating meta ..."
    scp -rp ${WORKSPACE}/* ${MANAGER_IP}:/var/lib/transwarp-manager/master/content/meta/services/
    ssh ${MANAGER_IP} /etc/init.d/transwarp-manager start
    ssh ${MANAGER_IP} /etc/init.d/transwarp-manager restart
    sleep 60
}

login() {
    curl -f -v -b cookies.txt -c cookies.txt -X POST \
      --data '{"userName": "'${MANAGER_USER}'", "userPassword": "'${MANAGER_PASS}'"}' \
      http://${MANAGER_IP}:${MANAGER_PORT}/api/users/login
}

SERVICE_TYPE_ID_MAP=()

create_global_service() {
    local service_type=$1
    local version=$2
    local deploy_mode=$3

    SERVICE_TYPE_ID_MAP[service_type]=$(
        curl -f -b cookies.txt -c cookies.txt -X POST \
            --data '[{"type":"'${service_type}'", "version": "'${version}'", "deployMode": "'${deploy_mode}'"}]' \
            http://${MANAGER_IP}:${MANAGER_PORT}/api/services |
                grep id | grep -oP '(?<=: ).*(?=,)'
    )
}

create_cluster_service() {
    local service_type=$1
    local version=$2
    local deploy_mode=$3

    SERVICE_TYPE_ID_MAP[service_type]=$(
        curl -f -b cookies.txt -c cookies.txt -X POST \
            --data '[{"type":"'${service_type}'", "version": "'${version}'", "clusterId": '${CLUSTER_ID}', "deployMode": "'${deploy_mode}'"}]' \
            http://${MANAGER_IP}:${MANAGER_PORT}/api/services |
                grep id | grep -oP '(?<=: ).*(?=,)'
    )
}

install_service() {
    local service_type=$1
    local service_id=${SERVICE_TYPE_ID_MAP[service_type]}

    local job_id=$(
        curl -f -b cookies.txt -c cookies.txt -X POST \
            http://${MANAGER_IP}:${MANAGER_PORT}/api/services/${service_id}/operations/init |
                grep id | cut -d':' -f2
    )
    polling_job ${job_id}
}

polling_job() {
    local job_id=$1

    for i in {1..MAX_TIMES}; do
        local job=$(
            curl -f -b cookies.txt -c cookies.txt -X GET \
                http://${MANAGER_IP}:${MANAGER_PORT}/api/operations/jobs/${job_id}
        )
        local status=$(echo ${job} | python -m json.tool | grep status | cut -d'"'  -f 4)
        local current_retry=1

        case "${status}" in
            WAITING|RUNNING)
                sleep ${SLEEP_SECONDS}
                ;;
            SUCCESSFUL)
                return 0
                ;;
            WARNING|IGNORED_WARNING|FAILED|IGNORED_FAILED)
                if (( ${current_retry} <= ${MAX_RETRY} )); then
                    local stage_ids=$(echo ${job} | python -c "
import sys; import json; job=json.loads(sys.stdin.read());
for stage in job[u'stages']:
  print stage[u'id']")
                for stage_id in ${stage_ids}; do
                    local stage=$(curl -f -b cookies.txt -c cookies.txt -X GET \
                      http://${MANAGER_IP}:${MANAGER_PORT}/api/operations/stages/${stage_id}
                    )
                    local stage_status=$(echo ${stage} | python -m json.tool | grep status |
                      cut -d'"' -f4
                    )
                    if [ ${stage_status} == "WARNING" -o ${stage_status} == "FAILED" ]; then
                        curl -f -b cookies.txt -c cookies.txt -X POST \
                            http://${MANAGER_IP}:${MANAGER_PORT}/api/operations/stages/${stage_id}/retry
                        ((current_retry++))
                        break
                    fi
                done
                else
                    return 1
                fi
                ;;
            *)
                echo "unexpected status ${status}"
                return 1
        esac
    done
    return 1
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

    update_meta

    login

    for service_type in ${start_sequence}; do
        create_cluster_service ${service_type} ${version} "KUBERNETES"
        install_service ${service_type}
    done

    # TODO enable Guardian
done
