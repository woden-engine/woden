#!/bin/bash
MY_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $MY_DIR/scripts/common.sh

bash "$WODEN2_SRC_TOP/scripts/fetchVM.sh" || exit 1

mkdir -p "$WODEN2_BUILD_DIST_DIR"
mkdir -p "$WODEN2_BUILD_DIR"

bash scripts/build-agpu.sh || exit 1
bash scripts/build-aphy.sh || exit 1

