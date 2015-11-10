#!/bin/bash
export WODEN2_SRC_TOP="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

bash ./buildDependencies.sh || exit 1
bash ./scripts/fetchVM.sh || exit 1

# Ensure the image folder is built.
IMAGE_DIR="$WODEN2_SRC_TOP/image"
mkdir -p "$IMAGE_DIR"
cd "$IMAGE_DIR"

# Fetch a new image and a new vm
wget -O- get.pharo.org/40 | bash

