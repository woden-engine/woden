#!/bin/bash
MY_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $MY_DIR/scripts/common.sh

# Ensure the image folder is built.
IMAGE_DIR="$WODEN2_SRC_TOP"
cd "$IMAGE_DIR"

# Fetch a new image
wget -O Pharo64.zip http://files.pharo.org/image/60/latest-64.zip || exit 1

# Decompress it
unzip Pharo64.zip

RAW_IMAGE_NAME=`ls Pharo64*.image`
BASE_NAME=`echo $RAW_IMAGE_NAME | sed 's/\\.image//g'`
mv "$BASE_NAME.image" "Pharo64.image"
mv "$BASE_NAME.changes" "Pharo64.changes"
