#!/usr/bin/env bash

# ensure we're not on a detached head
git checkout master

# until we switch to the new kubernetes / jenkins credential implementation use git credentials store
git config credential.helper store

export VERSION="$(jx-release-version)"
echo "Releasing version to ${VERSION}"

docker build -t docker.io/$ORG/$APP_NAME:${VERSION} .
docker push docker.io/$ORG/$APP_NAME:${VERSION}

#jx step tag --version ${VERSION}
git tag -fa v${VERSION} -m "Release version ${VERSION}"
git push origin v${VERSION}


