#!/usr/bin/env bash

build_application-metainfo() {
    set -e

    if [ "$CI_PROJECT_NAMESPACE" != "managability" ]; then
        echo "not in Project managability, exit ..."
        return 0
    fi

    META_SRC_DIR="$WORKSPACE"
    TARGET_DIR="/root/target"

    mkdir -p "$TARGET_DIR"

    for VERSION in final; do
        echo "preparing $VERSION ..."

        META_DST_DIR="$TARGET_DIR/$VERSION"

        cd "$META_SRC_DIR"
#        dirs=()
#        while IFS=  read -r -d $'\0'; do
#          dirs+=("$REPLY")
#        done < <(find . -name "$VERSION" -print0)
        if [ -d "$META_DST_DIR" ]; then
          rm -rf "$META_DST_DIR"
        fi
#        mkdir -p "$META_DST_DIR"
#        for dir in "${dirs[@]}"; do
#          mkdir -p "$META_DST_DIR/$dir"
#          cp -rp $dir/* "$META_DST_DIR/$dir/"
#        done

        rm -rf *.md script build_script .gitlab-ci.yml
        cp -rp . "$META_DST_DIR"

        # configure git remote options
        git config --global http.proxy 'http://172.16.2.14:7777'
        export http_proxy=http://172.16.2.14:7777
        export https_proxy=http://172.16.2.14:7777
        cd "$META_DST_DIR"
        # push to github
        curl -o /tmp/push_dev.sh http://172.16.2.71/pub/application-metainfo/push_dev.sh
        export BRANCH=master
        bash -x /tmp/push_dev.sh
        rm -f /tmp/push_dev.sh
        # set git remote for upgrade
        git remote rm origin
        git remote add origin https://github.com/transwarpio/application-metainfo.git
        http_proxy=http://172.16.2.14:7777 https_proxy=http://172.16.2.14:7777 git fetch origin
        git checkout master
        git branch --set-upstream-to=origin/master master


        echo "building $VERSION image ..."
        cd "$TARGET_DIR"
        rm -rf application-metainfo
        mv "$VERSION" application-metainfo
        ls application-metainfo
        echo 'FROM 172.16.1.41:5000/release/basefs:latest

RUN mkdir -p /root/application-metainfo
ADD application-metainfo /root/application-metainfo
' > Dockerfile

        POST_COMMIT_TAG="${DOCKER_REPO_URL}/postcommit/application-metainfo:$VERSION"
        GOLD_TAG="${DOCKER_REPO_URL}/gold/application-metainfo:$VERSION"

        docker build -t "$POST_COMMIT_TAG" .
        docker push "$POST_COMMIT_TAG"
        docker tag "$POST_COMMIT_TAG" "$GOLD_TAG"
        docker push "$GOLD_TAG"
    done
}
