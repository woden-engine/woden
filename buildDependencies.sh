#!/bin/bash
MY_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $MY_DIR/scripts/common.sh

bash "$WODEN2_SRC_TOP/scripts/fetchVM.sh" || exit 1

export WODEN2_BUILD_DIST_DIR="$WODEN2_SRC_TOP/vm/pharo-vm"
export WODEN2_BUILD_DIR="$WODEN2_SRC_TOP/build"

mkdir -p "$WODEN2_BUILD_DIST_DIR"
mkdir -p "$WODEN2_BUILD_DIR"

bash scripts/build-agpu.sh || exit 1

