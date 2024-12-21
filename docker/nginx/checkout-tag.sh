#!/bin/sh
cd /opt/h5bp/nginx
git fetch --tags
if [ "${H5BP_VERSION_ARG}" = "latest" ]; then
    tag=$(git describe --tags `git rev-list --tags --max-count=1`)
else
    tag=${H5BP_VERSION_ARG}
fi
echo "H5BP version: $tag"
git checkout $tag
