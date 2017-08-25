#!/bin/sh

VERSION=`cat version/number`-SNAPSHOT
MESSAGE="[Concourse CI] Bump to Next Development Version ($VERSION)"
export M2_HOME=../m2/rootfs/opt/m2

cd out
shopt -s dotglob
mv -f ../repo/* ./
git remote add -f master ../repo-master
git merge --no-edit master/master
echo "Bump to $VERSION"

rm gradle.properties
touch gradle.properties
echo version=$VERSION > gradle.properties
./mvnw versions:set -DnewVersion=${VERSION} -DallowSnapshots

git config --global user.email "${GIT_EMAIL}"
git config --global user.name "${GIT_NAME}"
git add pom.xml
git add gradle.properties
git commit -m "${MESSAGE}"
