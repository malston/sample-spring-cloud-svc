#!/bin/bash

cd out
shopt -s dotglob
mv -f ../to-repo/* ./
git config --global user.email "${GIT_EMAIL}"
git config --global user.name "${GIT_NAME}"
git remote add -f ${SOURCE_BRANCH_NAME} ../from-repo
git merge --no-edit ${SOURCE_BRANCH_NAME}/${SOURCE_BRANCH_NAME}