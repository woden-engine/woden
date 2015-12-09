#!/bin/bash
MY_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $MY_DIR/scripts/common.sh

bash ./buildDependencies.sh || exit 1

# Ensure the image folder is built.
IMAGE_DIR="$WODEN2_SRC_TOP"
cd "$IMAGE_DIR"

# Fetch a new image and a new vm
wget -O- get.pharo.org/50 | bash

# Load the repositories into the image
./pharo-ui Pharo.image st "$WODEN2_SRC_TOP/scripts/LoadRepositories.st"

