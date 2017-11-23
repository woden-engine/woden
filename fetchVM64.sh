#!/bin/bash
MY_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $MY_DIR/scripts/common64.sh

wget -O- http://get.pharo.org/64/vm61 | bash

$MY_DIR/useVM.sh "$MY_DIR/pharo-ui"
