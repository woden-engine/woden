#!/bin/bash
MY_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $MY_DIR/scripts/common32.sh

wget -O- http://get.pharo.org/vm61 | bash

OS="$(uname)"
if test "$OS" = "Darwin"; then
	$MY_DIR/useVM.sh "$MY_DIR/pharo-vm/Pharo.app/Contents/MacOS/Pharo"
else
	$MY_DIR/useVM.sh "$MY_DIR/pharo-ui"
fi
