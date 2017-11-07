#!/usr/bin/env bash

pull_merge_request() {
    local temp_branch=${gitlabSourceNamespace}/${gitlabSourceRepoName}-${gitlabSourceBranch}

    git fetch ${gitlabSourceRepoHttpUrl} ${gitlabSourceBranch}
    git checkout -b ${temp_branch} FETCH_HEAD

    git checkout ${gitlabTargetBranch}
    git merge --no-ff ${temp_branch} --no-edit --no-commit
}
