#!/bin/bash

if test `uname` = "Darwin"; then
    # On MacOS X, Metal works only on 64 bits mode. Avoid using the 64 bits VM, because
    # it is not completely stable yet.
    bash ./loadWoden2Image64.sh $@
else
    bash ./loadWoden2Image32.sh $@
fi
