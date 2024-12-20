#!/bin/bash
set -Eeuxo pipefail # https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/

pushd .
trap "popd" EXIT HUP INT QUIT TERM

CUR_GIT_ROOT=$(git rev-parse --show-toplevel)
VERSION_HASH=$(git rev-parse --short HEAD)

echo $VERSION_HASH > $CUR_GIT_ROOT/version_hash.txt

popd >& /dev/null


