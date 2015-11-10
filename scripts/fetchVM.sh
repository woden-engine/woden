#!/bin/bash
MY_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $MY_DIR/common.sh

VM_DIR="$WODEN2_SRC_TOP/vm"
if [ -d "$VM_DIR/pharo-vm" ]; then
    exit 0
fi

mkdir -p "$VM_DIR"
cd "$VM_DIR"

wget -O- get.pharo.org/vm | bash

