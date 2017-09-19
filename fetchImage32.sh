#!/bin/bash
MY_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $MY_DIR/scripts/common32.sh

# Ensure the image folder is built.
IMAGE_DIR="$WODEN2_SRC_TOP"
cd "$IMAGE_DIR"

# Fetch a new image
wget -O- get.pharo.org/61 | bash
