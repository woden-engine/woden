#!/bin/bash
MY_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $MY_DIR/scripts/common64.sh

wget -O- https://get.pharo.org/61/64/vm | bash

fetch_zip "http://files.pharo.org/get-files/61/sources.zip" PharoSourcesV61.zip || exit 1
