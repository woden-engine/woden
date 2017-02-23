#!/bin/bash
MY_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $MY_DIR/scripts/common32.sh

SOURCE_IMAGE_NAME="$1"

if test "$SOURCE_IMAGE_NAME" = ""; then
    SOURCE_IMAGE_NAME="Pharo.image"
fi

execVM $SOURCE_IMAGE_NAME st $WODEN2_SRC_TOP/scripts/LoadRepositories.st || exit 1
echo "Done loading image $SOURCE_IMAGE_NAME with Woden2"

