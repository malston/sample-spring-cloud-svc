#!/bin/bash

__DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

BRANCH=${1:-develop}
PIPELINE_NAME=${2:-sample-spring-cloud-svc}
ALIAS=${3:-docker}
CREDENTIALS=${4:-credentials.yml}

echo y | fly -t "${ALIAS}" sp -p "${PIPELINE_NAME}-${BRANCH}" -c "${__DIR}/pipeline-${BRANCH}.yml" -l "${__DIR}/${CREDENTIALS}"
