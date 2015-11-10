#!/bin/bash
MY_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $MY_DIR/scripts/common.sh

cd "$WODEN2_SRC_TOP"
rm -rf vm build build-dist image play-cache github-cache package-cache github-*.zip

