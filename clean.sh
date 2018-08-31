#!/bin/bash
MY_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $MY_DIR/scripts/common_scripts.sh

cd "$WODEN2_SRC_TOP"
rm -rf vm build build-dist pharo-vm native-libraries native-libraries-64 build-64 \
    play-cache github-cache package-cache github-*.zip \
    abstract-gpu abstract-physics core-assets pharo-local \
    __MACOSX woden2.sh Pharo* woden2.changes woden2.image \
    *.tar *.tar.gz *.zip *.so *.dylib *.dll *.pyc AgpuIcd source-deps \
    pharo pharo-ui woden.sh
