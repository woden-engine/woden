#!/bin/bash
MY_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $MY_DIR/common.sh

cd "$WODEN2_SRC_TOP"

wget -O- get.pharo.org/vm | bash

