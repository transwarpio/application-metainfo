#!/usr/bin/env bash

SCRIPT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source "$SCRIPT_DIR/util/jenkins_utils.sh"
source "$SCRIPT_DIR/util/git_utils.sh"

set -e

print_merge_params

pull_merge_request


