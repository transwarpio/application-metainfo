#!/usr/bin/env bash

build_application-metainfo() {
    SCRIPT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
    META_SRC_DIR="$SCRIPT_DIR"/../..
    TARGET_DIR="$META_SRC_DIR/target"

    mkdir -p "$TARGET_DIR"

    for VERSION in transwarp-5.1 transwarp-5.0 transwarp-ce-1.0; do
        echo "preparing $VERSION ..."

        META_DST_DIR="$TARGET_DIR/$VERSION"

        if [ ! -e "$META_SRC_DIR" ]; then
            echo "not found $META_SRC_DIR"
            return 1
        fi
        cd "$META_SRC_DIR"
        dirs=()
        while IFS=  read -r -d $'\0'; do
          dirs+=("$REPLY")
        done < <(find . -name "$VERSION" -print0)
        if [ -d "$META_DST_DIR" ]; then
          rm -rf "$META_DST_DIR"
        fi
        mkdir -p "$META_DST_DIR"
        for dir in "${dirs[@]}"; do
          mkdir -p "$META_DST_DIR/$dir"
          cp -rp $dir/* "$META_DST_DIR/$dir/"
        done


        echo "building $VERSION image ..."
        cd "$TARGET_DIR"
        rm -rf application-metainfo
        mv "$VERSION" application-metainfo
        echo 'FROM 172.16.1.41:5000/release/basefs:latest

RUN mkdir -p /root/application-metainfo
ADD application-metainfo /root/application-metainfo
' > Dockerfile

        POST_COMMIT_TAG="${DOCKER_REPO_URL}/postcommit/application-metainfo:$VERSION-alpha1"
        GOLD_TAG="${DOCKER_REPO_URL}/gold/application-metainfo:$VERSION-alpha1"

        docker build -t "$POST_COMMIT_TAG" .
        if [[ $? != 0 ]]; then
            return 1
        fi
        docker push "$POST_COMMIT_TAG"
        if [[ $? != 0 ]]; then
            return 1
        fi
        docker tag "$POST_COMMIT_TAG" "$GOLD_TAG"
        if [[ $? != 0 ]]; then
            return 1
        fi
        docker push "$GOLD_TAG"
        if [[ $? != 0 ]]; then
            return 1
        fi
    done
}
