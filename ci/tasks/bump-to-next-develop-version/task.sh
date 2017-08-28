#!/bin/bash

set -o errexit

CWD="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

export ROOT_FOLDER=$( pwd )
export REPO_RESOURCE=repo
export TOOLS_RESOURCE=tools
export VERSION_RESOURCE=version
export OUTPUT_RESOURCE=out

FUNCTIONS_FOLDER=${ROOT_FOLDER}/${TOOLS_RESOURCE}/functions
TASKS_FOLDER=${ROOT_FOLDER}/${TOOLS_RESOURCE}/tasks

echo "Root folder is [${ROOT_FOLDER}]"
echo "Repo resource folder is [${REPO_RESOURCE}]"
echo "Tools resource folder is [${TOOLS_RESOURCE}]"
echo "Version resource folder is [${VERSION_RESOURCE}]"
echo "Functions folder is [${FUNCTIONS_FOLDER}]"
echo "Tasks folder is [${TASKS_FOLDER}]"

export PIPELINE_VERSION=$( cat ${ROOT_FOLDER}/${VERSION_RESOURCE}/version )
echo "Retrieved version is [${PIPELINE_VERSION}]"

export CI="CONCOURSE"
export ENVIRONMENT=BUILD

source ${TASKS_FOLDER}/common.sh

cd ${ROOT_FOLDER}/${REPO_RESOURCE}

# CURRENTLY WE ONLY SUPPORT JVM BASED PROJECTS OUT OF THE BOX
[[ -f "${FUNCTIONS_FOLDER}/projectType/pipeline-jvm.sh" ]] && source "${FUNCTIONS_FOLDER}/projectType/pipeline-jvm.sh" || \
    echo "No ${FUNCTIONS_FOLDER}/projectType/pipeline-jvm.sh found"

export TERM=dumb

echo "Bump to ${VERSION}"
VERSION=${PIPELINE_VERSION}-SNAPSHOT
MESSAGE="[Concourse CI] Bump to Next Development Version ($VERSION)"
export M2_HOME=../m2/rootfs/opt/m2

cd ${ROOT_FOLDER}/${OUTPUT_RESOURCE}
shopt -s dotglob
mv -f ../repo/* ./
git remote add -f master ../repo-master
git merge --no-edit master/master

lowerCaseProjectType=$( echo "${PROJECT_TYPE}" | tr '[:upper:]' '[:lower:]' )
[[ -f "${CWD}/projectType/pipeline-${lowerCaseProjectType}.sh" ]] && source "${CWD}/projectType/pipeline-${lowerCaseProjectType}.sh" || \
    echo "No ${CWD}/projectType/pipeline-${lowerCaseProjectType}.sh found"

bumpVersion
