#!/bin/bash

set -e -u

git clone repo out
pushd out
  git config --local user.email "${GIT_EMAIL}"
  git config --local user.name "${GIT_NAME}"

  echo "Create branch ${BRANCH_NAME}"

  git checkout -B "${BRANCH_NAME}"
popd
