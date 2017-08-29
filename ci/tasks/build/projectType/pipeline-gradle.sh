#!/bin/bash
set -e

function build() {
    echo "Additional Build Options [${BUILD_OPTIONS}]"

    if [[ "${CI}" == "CONCOURSE" ]]; then
        ./gradlew clean build -PnewVersion=${PIPELINE_VERSION} --stacktrace ${BUILD_OPTIONS} || ( $( printTestResults ) && return 1)
    else
        ./gradlew clean build -PnewVersion=${PIPELINE_VERSION} --stacktrace ${BUILD_OPTIONS}
    fi

    local artifactId=$( retrieveAppName )
    local groupId=$( retrieveGroupId )
    local changedGroupId="$( echo "${groupId}" | tr . / )"
    local artifactVersion=${PIPELINE_VERSION}
    TARGET_FOLDER="build/libs"

    echo "Copying artifacts from [${ROOT_FOLDER}/${REPO_RESOURCE}/${TARGET_FOLDER}] to [${ROOT_FOLDER}/${OUTPUT_RESOURCE}]"
    mkdir -p ${ROOT_FOLDER}/${OUTPUT_RESOURCE}/${changedGroupId}/${artifactId}/${artifactVersion}/
    cp -p ${ROOT_FOLDER}/${REPO_RESOURCE}/${TARGET_FOLDER}/${artifactId}-${artifactVersion}.jar ${ROOT_FOLDER}/${OUTPUT_RESOURCE}/${changedGroupId}/${artifactId}/${artifactVersion}/${artifactId}-${artifactVersion}.jar
}

export -f build
