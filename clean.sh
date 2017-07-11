#!/bin/bash
MY_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $MY_DIR/scripts/common_scripts.sh

cd "$WODEN2_SRC_TOP"
rm -rf vm build build-dist pharo-vm native-libraries native-libraries-64 build-64 \
    play-cache github-cache package-cache github-*.zip \
    abstract-gpu woden2.sh Pharo*
