#!/bin/bash

if test `uname` = "Darwin"; then
    # On MacOS X, Metal works only on 64 bits mode
    bash ./loadWoden64.sh
else
    bash ./loadWoden32.sh
fi
