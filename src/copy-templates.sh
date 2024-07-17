#!/bin/sh

if [[ -z "$COPYIN_REPO" ]]
then
    echo "Missing COPYIN_REPO" 1>&2
    exit 1
fi

echo "S3 copy-in repo=$COPYIN_REPO" 1>&2

T=$(mktemp -d)
cd $T

if [[ -n $COPYIN_user ]]
then
    PAT_USER=$(echo -n $COPYIN_user | base64 -d)
    PAT=$(echo -n $COPYIN_pat | base64 -d)

    # add user and personal access token
    _COPYIN_URL=$(echo "$COPYIN_REPO" | sed -E "s#(https://)([^/]+)/.+\$#\1$PAT_USER:$PAT@\2#")
else
    _COPYIN_URL=$(echo "$COPYIN_REPO" | sed -E "s#(https://)([^/]+)/.+\$#\1\2#")
fi


_COPYIN_ORG=$(echo "$COPYIN_REPO" | sed -E 's#https://[^/]+/([^/]+)/.+$#\1#')
_COPYIN_REPO=$(echo "$COPYIN_REPO" | sed -E 's#https://[^/]+/[^/]+/([^/]+)/.+$#\1#')
_COPYIN_BRANCH=$(echo "$COPYIN_REPO" | sed -E 's#https://[^/]+/[^/]+/[^/]+/tree/([^/]+)/.+$#\1#')
_COPYIN_SUBDIR=$(echo "$COPYIN_REPO" | sed -E 's#https://[^/]+/[^/]+/[^/]+/tree/[^/]+/(.+)$#\1#')

_COPYIN_FULL="${_COPYIN_URL}/${_COPYIN_ORG}/${_COPYIN_REPO}.git"

echo "Cloning repo for copy-in ${_COPYIN_FULL}" 1>&2

git clone --quiet --no-checkout --filter=blob:none ${_COPYIN_FULL} -b ${_COPYIN_BRANCH} 1>&2
cd $_COPYIN_REPO

echo "Sparse checkout for copy-in branch=${_COPYIN_BRANCH} subdir=${_COPYIN_SUBDIR}" 1>&2
git sparse-checkout set --cone $_COPYIN_SUBDIR 1>&2
git checkout -q ${_COPYIN_BRANCH} 1>&2

cd "${_COPYIN_SUBDIR}" && pwd
