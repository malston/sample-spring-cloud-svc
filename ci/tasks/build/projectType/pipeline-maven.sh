#!/bin/bash
set -e

# It takes ages on Docker to run the app without this
if [[ ${BUILD_OPTIONS} != *"java.security.egd"* ]]; then
    if [[ ! -z ${BUILD_OPTIONS} && ${BUILD_OPTIONS} != "null" ]]; then
        export BUILD_OPTIONS="${BUILD_OPTIONS} -Djava.security.egd=file:///dev/urandom"
    else
        export BUILD_OPTIONS="-Djava.security.egd=file:///dev/urandom"
    fi
fi

function build() {
    echo "Additional Build Options [${BUILD_OPTIONS}]"

    ./mvnw versions:set -DnewVersion=${PIPELINE_VERSION} ${BUILD_OPTIONS}
    if [[ "${CI}" == "CONCOURSE" ]]; then
        ./mvnw clean package ${BUILD_OPTIONS} || ( $( printTestResults ) && return 1)
    else
        ./mvnw clean package ${BUILD_OPTIONS}
    fi

    local artifactId=$( retrieveAppName )
    local groupId=$( retrieveGroupId )
    local changedGroupId="$( echo "${groupId}" | tr . / )"
    local artifactVersion=${PIPELINE_VERSION}
    TARGET_FOLDER="target"

    echo "Copying artifacts from [${ROOT_FOLDER}/${REPO_RESOURCE}/${TARGET_FOLDER}] to [${ROOT_FOLDER}/${OUTPUT_RESOURCE}]"
    mkdir -p ${ROOT_FOLDER}/${OUTPUT_RESOURCE}/${changedGroupId}/${artifactId}/${artifactVersion}/
    cp -p ${ROOT_FOLDER}/${REPO_RESOURCE}/${TARGET_FOLDER}/${artifactId}-${artifactVersion}.jar ${ROOT_FOLDER}/${OUTPUT_RESOURCE}/${changedGroupId}/${artifactId}/${artifactVersion}/${artifactId}-${artifactVersion}.jar
}

export -f build
