#!/bin/bash
MY_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $MY_DIR/scripts/common32.sh

#Optional argument, image to load
IMAGE_NAME="$1"

# Fetch the 32 bits VM, only if a VM is not avaialable.
if test ! -e "$WODEN2_SRC_TOP/woden2.sh" ; then
    bash "$WODEN2_SRC_TOP/fetchVM32.sh" || exit 1
fi

# Fetch the image
bash "$WODEN2_SRC_TOP/fetchImage32.sh" "$IMAGE_NAME"|| exit 1

# Build the libraries
bash "$WODEN2_SRC_TOP/buildDependencies32.sh" || exit 1

# Load the Woden 2 image.
bash "$WODEN2_SRC_TOP/loadWoden2Image32.sh" || exit 1
echo "DONE"
