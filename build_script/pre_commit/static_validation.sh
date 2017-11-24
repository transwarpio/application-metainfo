#!/usr/bin/env bash

DB_PROPERTY=/root/test-new/db.properties
OUTPUT_PATH=/var/lib/transwarp-manager/mock
DOCKER_IMAGE="tptest"
DIFF_FILES=()

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
    AFFECTED_VERSIONS=($(git diff origin/${gitlabTargetBranch} | perl -nle 'm\ [ab]/([^/]*)/(transwarp-[^/]*)/\; print $2' | sort | uniq))
}


calc_affected_services() {
    current_version=$1

    affected_services=$(git diff origin/${gitlabTargetBranch} | perl -nle 'm\ [ab]/([^/]*)/'${current_version}'/\; print $1' | sort | uniq)
}



print_merge_params

pull_merge_request

calc_affected_versions
echo "affected versions: ${AFFECTED_VERSIONS[@]}"

for version in "${AFFECTED_VERSIONS[@]}"; do
    echo "# testing $version ..."
    calc_affected_services "$version"
    echo "modified services: ${affected_services}"

    for service in ${affected_services}; do
        testcase_path=${WORKSPACE}/$service/$version/test
        if ! [ -d $testcase_path ]; then
            continue;
        fi
        test_cases=($(ls $testcase_path))

        for each_case in ${test_cases[@]}; do
            test_context=$testcase_path/${each_case}/context.yaml
            #rm -rf ${OUTPUT_PATH}/*
            #run template test framework
            docker run -v $DB_PROPERTY:/etc/transwarp-manager/master/db.properties -v $test_context:/etc/transwarp-manager/master/context.yaml -v ${WORKSPACE}:/var/lib/transwarp-manager/master/content/meta/services/ -v $OUTPUT_PATH:/var/lib/transwarp-manager/mock/ ${DOCKER_IMAGE} bash /home/test.sh

            test_nodes=($(ls -F $testcase_path/$each_case | grep "/$" | sed 's/\/$//g'))
            for each_node in ${test_nodes[@]}; do
                reference_files=($(ls $testcase_path/$each_case/$each_node))
                for each_file in ${reference_files[@]}; do
                    reference_file=$testcase_path/$each_case/$each_node/$each_file
                    service_name=`echo $(cat ${WORKSPACE}/$service/$version/metainfo.yaml | grep "^namePrefix:" | awk -F : '{print $2}') | tr 'A-Z' 'a-z'`
                    acutal_file=$OUTPUT_PATH/$each_node/etc/$service_name*/conf/$each_file
                    if ! diff $reference_file $acutal_file > /dev/null
                    then
                        DIFF_FILES=("${DIFF_FILES[@]}" "$reference_file")
                    fi
                done
            done
        done
    done
done

if [ ${#DIFF_FILES[@]} -gt 0 ]
then
  echo "The following reference files are different from actual outcoming files:"
  for difference in "${DIFF_FILES[@]}"; do
      echo "${difference}"
  done
  exit 1
else
  echo "Template Static Validation Passed. Congratulations!"
fi