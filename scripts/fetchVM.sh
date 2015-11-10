#!/bin/bash

VM_DIR="$WODEN2_SRC_TOP/vm"
mkdir -p "$VM_DIR"
cd "$VM_DIR"

wget -O- get.pharo.org/vm | bash

