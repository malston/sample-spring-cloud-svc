#!/bin/bash

__DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

PIPELINE_NAME=${2:-sample-spring-cloud-svc}
ALIAS=${3:-docker}
CREDENTIALS=${4:-credentials.yml}

fly -t "${ALIAS}" sp -p "${PIPELINE_NAME}" -c "${__DIR}/pipeline.yml" -l "${__DIR}/${CREDENTIALS}" -n
