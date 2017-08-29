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
        ./mvnw clean verify deploy -Ddistribution.management.release.id=${M2_SETTINGS_REPO_ID} -Ddistribution.management.release.url=${REPO_WITH_BINARIES} -Ddistribution.management.snapshot.url=${REPO_WITH_SNAPSHOT_BINARIES} -Drepo.with.binaries=${REPO_WITH_BINARIES} ${BUILD_OPTIONS} || ( $( printTestResults ) && return 1)
    else
        ./mvnw clean verify deploy -Ddistribution.management.release.id=${M2_SETTINGS_REPO_ID} -Ddistribution.management.release.url=${REPO_WITH_BINARIES} -Ddistribution.management.snapshot.url=${REPO_WITH_SNAPSHOT_BINARIES} -Drepo.with.binaries=${REPO_WITH_BINARIES} ${BUILD_OPTIONS}
    fi

    local artifactId="sample-spring-cloud-svc"
    local groupId="org.bk"
    local artifactVersion="1.0.4-SNAPSHOT"

    echo "Copying artifacts from target/ to ../out"
    mkdir -p out/org/bk/${artifactId}/${artifactVersion}/
    cp -p target/${artifactId}-${artifactVersion}.jar ../out/org/bk/${artifactId}/${artifactVersion}/${artifactId}-${artifactVersion}.jar
}

export -f build
