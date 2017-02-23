#!/bin/sh
export WODEN2_SRC_TOP="$( cd "$( dirname "${BASH_SOURCE[0]}" )"/.. && pwd )"

export WODEN2_BUILD_DIST_DIR="$WODEN2_SRC_TOP/native-libraries-32"
export WODEN2_BUILD_DIR="$WODEN2_SRC_TOP/build-32"

export WODEN_DEPS_CMAKE_FLAGS=''
export WODEN_ARCH=`uname -m`

if test "$WODEN_ARCH"  = "x86_64"; then
    export WODEN_DEPS_CMAKE_FLAGS='-DCMAKE_CXX_FLAGS=-m32 -DCMAKE_C_FLAGS=-m32'
fi

source "$WODEN2_SRC_TOP/scripts/common_scripts.sh"
