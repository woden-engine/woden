#!/bin/bash
export WODEN2_SRC_TOP="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
export WODEN2_BUILD_DIST_DIR="$WODEN2_SRC_TOP/build-dist"
export WODEN2_BUILD_DIR="$WODEN2_SRC_TOP/build"

mkdir -p "$WODEN2_BUILD_DIST_DIR"
mkdir -p "$WODEN2_BUILD_DIR"

bash scripts/build-agpu.sh || exit 1

