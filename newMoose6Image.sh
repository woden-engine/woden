#!/bin/bash
MY_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $MY_DIR/scripts/common.sh

bash ./buildDependencies.sh || exit 1

# Ensure the image folder is built.
IMAGE_DIR="$WODEN2_SRC_TOP"
cd "$IMAGE_DIR"

# Download the Moose 6 image
wget -c https://ci.inria.fr/moose/job/moose-6.0/lastSuccessfulBuild/artifact/moose-6.0.zip || exit 1
unzip moose-6.0.zip || exit 1
rm -f moose-6.0.zip

# Load the repositories into the image
./pharo-ui moose-6.0.image st "$WODEN2_SRC_TOP/scripts/LoadRepositories.st"

