#!/bin/bash
MY_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $MY_DIR/scripts/common32.sh

mkdir -p "$WODEN2_BUILD_DIST_DIR"
mkdir -p "$WODEN2_BUILD_DIR"

bash scripts/build-agpu.sh || exit 1
bash scripts/build-aphy.sh || exit 1
bash scripts/build-core-assets.sh || exit 1
bash scripts/build-lowtalk.sh || exit 1
bash scripts/build-phanide.sh || exit 1
