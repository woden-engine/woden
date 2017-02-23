#!/bin/sh
export WODEN2_SRC_TOP="$( cd "$( dirname "${BASH_SOURCE[0]}" )"/.. && pwd )"

export WODEN2_BUILD_DIST_DIR="$WODEN2_SRC_TOP/native-libraries-64"
export WODEN2_BUILD_DIR="$WODEN2_SRC_TOP/build-64"

export WODEN_DEP_LIB_CMAKE_FLAGS=''
export WODEN_DEPS_CMAKE_FLAGS=''
export WODEN_ARCH=`uname -m

source "$WODEN2_SRC_TOP/scripts/common_scripts.sh"
