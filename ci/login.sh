#!/bin/bash

TARGET=${1:-docker}
ROOT_ADDRESS=${2:-`./whats_my_ip.sh`}
CONCOURSE_URL=${3:-"http://${ROOT_ADDRESS}:8080"}
CONCOURSE_USER=${4:-concourse}
CONCOURSE_PASSWORD=${5:-changeme}
TEAM=${6:-main}

fly -t "${TARGET}" login -c "${CONCOURSE_URL}" -u "${CONCOURSE_USER}" -p "${CONCOURSE_PASSWORD}" -n "${TEAM}"
