#!/bin/bash
set -e

function build() {
    echo "Additional Build Options [${BUILD_OPTIONS}]"

    if [[ "${CI}" == "CONCOURSE" ]]; then
        ./gradlew clean build deploy -PnewVersion=${PIPELINE_VERSION} -DREPO_WITH_BINARIES=${REPO_WITH_BINARIES} --stacktrace ${BUILD_OPTIONS} || ( $( printTestResults ) && return 1)
    else
        ./gradlew clean build deploy -PnewVersion=${PIPELINE_VERSION} -DREPO_WITH_BINARIES=${REPO_WITH_BINARIES} --stacktrace ${BUILD_OPTIONS}
    fi

    local artifactId="sample-spring-cloud-svc"
    local groupId="org.bk"
    local artifactVersion="1.0.4-SNAPSHOT"

    echo "Copying artifacts from build/libs to ../out"
    cp -p build/libs/${artifactId}-${artifactVersion}.jar ../out/org/bk/${artifactId}/${artifactVersion}/${artifactId}-${artifactVersion}.jar
}

export -f build
